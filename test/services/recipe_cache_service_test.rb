require 'test_helper'

class RecipeCacheServiceTest < ActiveSupport::TestCase
  def setup
    # as we are testing the caching behavior here,
    # we need to clear out the cache before each test case
    Rails.cache.clear
  end

  test 'list calls Recipe.all just once if called multiple times' do
    Recipe.expects(:all).once.returns(recipes)

    result = RecipeCacheService.list(pagination_params)
    assert_equal recipes.map(&:id).sort, result.map(&:id).sort

    # should hit the cache, and not Recipe.all
    result = RecipeCacheService.list(pagination_params)
    assert_equal recipes.map(&:id).sort, result.map(&:id).sort
  end

  test 'list would also cache separate entries' do
    recipe = recipes.first
    Recipe.expects(:find).never
    Recipe.expects(:all).once.returns(recipes)

    # call list to get all recipes and cache them
    result = RecipeCacheService.list(pagination_params)
    assert recipe.id.in?(result.map(&:id))

    # should hit the cache, and not Recipe.find
    result = RecipeCacheService.find(recipe.id)
    assert_equal recipe.id, result.id
  end

  test 'find calls Recipe.find just once if called multiple times' do
    recipe = recipes.first
    Recipe.expects(:find).once.returns(recipe)

    result = RecipeCacheService.find(recipe.id)
    assert_equal recipe.id, result.id

    # should hit the cache, and not Recipe.find
    result = RecipeCacheService.find(recipe.id)
    assert_equal recipe.id, result.id
  end

  private

  def pagination_params
    @pagination_params ||= {per_page: 2, page: 1}
  end
end
