class ProductsController < ApplicationController
  def all_products
    products = Product.all

    products_array = products.map { |shirt| 
      {
      name: shirt.name,
      size: shirt.size,
      price: shirt.price,
      image_url: shirt.image_url,
      description: shirt.description
      }
     }

    render json: products_array.as_json
  end
end
