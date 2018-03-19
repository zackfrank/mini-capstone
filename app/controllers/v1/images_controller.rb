class V1::ImagesController < ApplicationController

  def index
    images = Image.all.order(:id)
    render json: images.as_json
  end

  def create
    image = Image.new( 
      { title: params["title"],
        description: params["description"],
        url: params["url"],
        product_id: params["product_id"]
      })

    if image.save
      render json: image.as_json
    else
      render json: {errors: image.errors.full_messages}, status: 422
    end
  end

  def show
    id = params[:id].to_i
    image = Image.find_by(id: id)
    render json: image.as_json
  end

  def update
    id = params[:id].to_i
    image = Image.find_by(id: id)
    image.title = params["title"] || image.title
    image.url = params["url"] || image.url
    image.description = params["description"] || image.description
    image.product_id = params["product_id"] || image.product_id

    if image.save
      render json: image.as_json
    else
      render json: {errors: image.errors.full_messages}, status: 422
    end
    
  end

end
