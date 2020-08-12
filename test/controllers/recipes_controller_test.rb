require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    # stub the RecipesProvider calls, as they are tested separately
    RecipeCacheService.expects(:list).returns(paginated_recipes)
    get recipes_url

    assert_response :success
  end

  test 'should show recipe' do
    recipe = recipes.first
    # stub the RecipesProvider calls, as they are tested separately
    RecipeCacheService.expects(:find).returns(recipe)
    get recipe_url(recipe.id)

    assert_response :success
  end

  private

  def paginated_recipes
    WillPaginate::Collection.create(1, 3, recipes.count) do |pager|
      pager.replace(recipes)
    end
  end
end
