class V1::ProductsController < ApplicationController
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

  def product_by_id
    id = params["id"].to_i
    product = Product.find_by("id": id)
    render json: {product: product}
  end
end
