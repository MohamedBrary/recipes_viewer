class RecipesController < ApplicationController
  PER_PAGE = 3
  PAGE = 1

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = RecipeCacheService.list(per_page: per_page_param, page: page_param)
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @recipe = RecipeCacheService.find(params[:id])
  end

  private

  def page_param
    raise Exceptions::BadRequest if params[:page].present? && params[:page].to_i <= 0

    (params[:page].presence || PAGE).to_i
  end

  def per_page_param
    raise Exceptions::BadRequest if params[:per_page].present? && params[:per_page].to_i <= 0

    (params[:per_page].presence || PER_PAGE).to_i
  end

end
