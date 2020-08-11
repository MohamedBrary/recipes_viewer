require 'singleton'

# this class serves as an abstract class for all recipe sources
# these methods are expected to be implemented in each subclass
# here also the standarized error handling would take place
class RecipesProviders::Source
  include Singleton

  # ---------
  # Fetching Recipes

  # returns paginated array of recipes
  def list(params)
    raise NotImplementedError
  end

  # returns one recipe
  # raises Exceptions::RecordNotFound when recipe not found
  def find(id)
    raise NotImplementedError
  end

  # ---------
  # Recipes Processing

  # transforms the external recipe to our recipe scheme
  def to_recipe(external_recipe)
    raise NotImplementedError
  end

  # ---------
  # Error Handling

  def handle_service_unavailable(exception=nil, message=nil)
    # TODO report the issue
    raise RecipesProviders::Exceptions::ServiceUnavailable
  end
end
