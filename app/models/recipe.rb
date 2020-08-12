class Recipe
  attr_accessor :id, :title, :image, :tags, :description, :chef_name
  def image
    @image || 'logo.png'
  end

  class << self

    def all(per_page: 3, page: 1)
      RecipesProvider.from_default.list(per_page: per_page, page: page)
    end

    # raises Exceptions::RecordNotFound when recipe not found
    def find(id)
      RecipesProvider.from_default.find(id)
    end

    def all_samples
      return @all_samples if @all_samples

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

      @all_samples = WillPaginate::Collection.create(1, recipes.count, recipes.count) do |pager|
        pager.replace(recipes)
      end
    end

  end

end
