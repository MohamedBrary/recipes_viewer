class RecipesProviders::Contentful < RecipesProviders::Source
  attr_accessor :client

  RECIPE_CT_ID = 'recipe'

  def initialize
    @client = Contentful::Client.new(
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN'],
      space: ENV['CONTENTFUL_SPACE_ID'],
      dynamic_entries: :auto,
      raise_errors: true
    )
  end

  # ---------
  # Fetching Recipes

  # returns paginated array of recipes
  def list(per_page: 3, page: 1)
    params = {
      skip: (page-1)*per_page,
      limit: per_page
    }
    entries = fetch(params)
    # to support pagination for plain arrays, by utlizing 'entries.total' from the
    WillPaginate::Collection.create(page, per_page, entries.total) do |pager|
      pager.replace(entries.map { |entry| to_recipe(entry) })
    end
  end

  # returns one recipe
  # raises Exceptions::RecordNotFound when recipe not found
  def find(id)
    params = {
      'sys.id': id
    }
    entry = fetch(params).first
    raise Exceptions::RecordNotFound if entry.blank?

    to_recipe(entry)
  end

  def fetch(params)
    params = {
      content_type: RECIPE_CT_ID,
      include: 1
    }.merge(params)

    begin
      client.entries(params)
    rescue Contentful::ServiceUnavailable => exception
      handle_service_unavailable(exception, 'contentful is out!')
    end
  end

  # ---------
  # Recipes Processing

  # transforms the external recipe to our recipe scheme
  def to_recipe(external_recipe)
    return nil if external_recipe.blank?

    recipe = Recipe.new

    recipe.id = external_recipe.id
    recipe.title = external_recipe.title
    recipe.description = external_recipe.description
    # handling links through raw response, as they might not exist in all entries
    raw_fields = external_recipe.raw_with_links['fields']
    recipe.tags = raw_fields['tags']&.map(&:name)&.join('. ')
    recipe.chef_name = raw_fields['chef']&.name
    recipe.image = raw_fields['photo']&.url

    recipe
  end
end
