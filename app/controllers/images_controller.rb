class ImagesController < ApplicationController

  def update
    image = Image.find_by(id: params["id"])
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
