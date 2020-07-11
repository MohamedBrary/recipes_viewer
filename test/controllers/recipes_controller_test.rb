require 'test_helper'

class RecipesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get recipes_url
    assert_response :success
  end

  test 'should show recipe' do
    @recipe = Recipe.all.first
    get recipe_url(@recipe.id)
    assert_response :success
  end
end
