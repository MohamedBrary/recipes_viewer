# A factory class for different recipe providers
# it takes the recipes source name, and returns its RecipesProvider::Source object
class RecipesProvider

  RECIPES_PROVIDERS = [:contentful].freeze

  def self.from(source)
    case source
    when :contentful
      RecipesProviders::Contentful.instance
    else
      raise NotImplementedError
    end
  end

  def self.from_default
    from(:contentful)
  end

end
