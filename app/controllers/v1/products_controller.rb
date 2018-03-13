class V1::ProductsController < ApplicationController
  
  def index
    products = Product.all

    # products_array = products.map { |shirt| 
    #   {
    #   name: shirt.name,
    #   size: shirt.size,
    #   price: shirt.price,
    #   image_url: shirt.image_url,
    #   description: shirt.description
    #   }
    # }
    # render json: products_array.as_json
    render json: products.as_json
  end

  def show
    id = params["id"].to_i
    product = Product.find_by(id: id)
    render json: product.as_json
  end

  def create
    product = Product.create(
      name: params["name"], 
      size: params["size"],
      price: params["price"], 
      # image_url: params["image_url"],
      description: params["description"]
      )

    render json: product.as_json
  end

  def update
    product = Product.find_by(id: params["id"])
    product.name = params["name"] || product.name
    product.size = params["size"] || product.size
    product.price = params["price"] || product.price
    product.description = params["description"] || product.description

    product.save

    render json: product.as_json
  end

  def destroy
    product = Product.find_by(id: params["id"])
    product.destroy

    render json: {message: "Product successfully deleted."}
  end

end
