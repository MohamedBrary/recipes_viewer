class Recipe
  attr_accessor :id, :title, :image, :tags, :description, :chef_name

  def self.all
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

  def image
    @image || 'logo.png'
  end
end
