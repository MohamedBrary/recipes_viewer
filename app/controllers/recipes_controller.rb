class RecipesController < ApplicationController

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.all(page: page_param)
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def page_param
    raise Exceptions::BadRequest if params[:page].present? && params[:page].to_i <= 0

    (params[:page].presence || 1).to_i
  end

end
