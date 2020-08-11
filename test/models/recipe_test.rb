require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test 'all calls a source list method' do
    test_result = ['test']
    RecipesProviders::Contentful.any_instance.stubs(:list).returns(test_result)

    assert_equal test_result, Recipe.all
  end

  test 'find calls a source find method' do
    test_result = 'test'
    RecipesProviders::Contentful.any_instance.stubs(:find).returns(test_result)

    assert_equal test_result, Recipe.find('any')
  end
end
