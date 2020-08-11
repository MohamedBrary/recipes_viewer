require 'test_helper'

# TODO as these tests do http requests and would be slow, we can separate them into a test group
# and control running it with an ENV variable
class RecipesProviderTest < ActiveSupport::TestCase

  # this current design of RecipesProvider allows for basic smoke testing for each provider added
  # as each provider is expected to follow a certain behavior, and implement set of methods
  RecipesProvider::RECIPES_PROVIDERS.each do |provider|
    provider_source_klass_name = "RecipesProviders::#{provider.to_s.classify}"
    provider_source_klass = provider_source_klass_name.constantize

    # make sure each provider is accessible through the RecipesProvider factory
    # and that it inherits from RecipesProviders::Source
    test "RecipesProvider.from(:#{provider}) returns #{provider_source_klass_name}" do
      provider_source = RecipesProvider.from(provider)
      assert provider_source.is_a?(RecipesProviders::Source)
      assert provider_source.is_a?(provider_source_klass)
    end

    # smoke tests for list and find methods
    test "#{provider_source_klass_name} implements list and find methods" do
      provider_source = RecipesProvider.from(provider)
      retrieved_recipes = provider_source.list
      # test that it returns a list of Recipe objects
      assert_equal [Recipe], retrieved_recipes.map(&:class).uniq unless retrieved_recipes.blank?

      begin
        recipe = provider_source.find(retrieved_recipes.first&.id)
        assert_equal Recipe, recipe.class
      rescue Exceptions::RecordNotFound
        # if recipe not found it should raise Exceptions::RecordNotFound
      end
    end

    test "#{provider_source_klass_name}.find raises Exceptions::RecordNotFound when recipe not found" do
      assert_raise(Exceptions::RecordNotFound) {
        provider_source = RecipesProvider.from(provider)
        provider_source.find('no way this is an id for any record anywhere')
      }
    end
  end

end
