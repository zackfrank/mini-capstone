class V1::CategoriesController < ApplicationController
  def index
    categories = Category.all
    render json: categories.as_json
  end

  def show
    id = params[:id].to_i
    category = Category.find_by(id: id)
    render json: category.as_json
  end
end
