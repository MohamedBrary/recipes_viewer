class Recipe
  attr_accessor :id, :title, :image, :tags, :description, :chef_name
  def image
    @image || 'logo.png'
  end

  # TODO move it to the wrapper in lib
  CONTENTFUL_RECIPE_CT_ID = 'recipe'

  class << self

    def all_samples
      # I have no idea why I am doing that, but I am going to finish it
      fixtures = YAML.load(File.read(File.join(Rails.root, 'test', 'fixtures', 'recipes.yml')))
      recipes = []

      fixtures.values.each_with_index do |fixture, index|
        recipe = Recipe.new
        recipe.id = index
        fixture.keys.each do |recipe_attr|
          recipe.send("#{recipe_attr}=", fixture[recipe_attr])
        end
        recipes << recipe
      end

      recipes
    end

    # TODO check caching options
    def all(per_page: 3, page: 1)
      params = {
        skip: (page-1)*per_page,
        limit: per_page
      }
      entries = fetch(params)
      # to support pagination for plain arrays
      WillPaginate::Collection.create(page, per_page, entries.total) do |pager|
        pager.replace entries.map { |entry| to_recipe(entry) }
      end
    end

    def find(id)
      params = {
        'sys.id': id
      }
      entry = fetch(params).first
      to_recipe(entry)
    end

    def fetch(params)
      params = {
        content_type: CONTENTFUL_RECIPE_CT_ID,
        include: 1
      }.merge(params)

      client.entries(params)
    end

    private

    # TODO move it to the wrapper in lib
    # TODO make it a singleton object
    def client
      @client ||= Contentful::Client.new(
        access_token: ENV['CONTENTFUL_ACCESS_TOKEN'],
        space: ENV['CONTENTFUL_SPACE_ID'],
        dynamic_entries: :auto,
        raise_errors: true
      )
    end

    # TODO move it to the wrapper in lib
    # object to object transformation
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

end
