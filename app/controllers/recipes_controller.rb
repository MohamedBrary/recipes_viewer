class RecipesController < ApplicationController

  # GET /recipes
  # GET /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/1
  # GET /recipes/1.json
  def show
    @recipes = Recipe.all
    @recipe = @recipes.select{|r| r.id.to_s == params[:id].to_s}.first
  end

end
