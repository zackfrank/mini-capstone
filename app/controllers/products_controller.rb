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

  def shirt1_xs
    shirt = Product.find_by(id: 1)
    shirt_array = 
    {
      name: shirt.name,
      size: shirt.size,
      price: shirt.price,
      image_url: shirt.image_url,
      description: shirt.description
    }

    render json: shirt_array.as_json
  end

  def shirt1_sm
    shirt = Product.find_by(id: 2)
    shirt_array = 
    {
      name: shirt.name,
      size: shirt.size,
      price: shirt.price,
      image_url: shirt.image_url,
      description: shirt.description
    }

    render json: shirt_array.as_json
  end

  def shirt1_md
    shirt = Product.find_by(id: 3)
    shirt_array = 
    {
      name: shirt.name,
      size: shirt.size,
      price: shirt.price,
      image_url: shirt.image_url,
      description: shirt.description
    }

    render json: shirt_array.as_json
  end

  def shirt1_lg
    shirt = Product.find_by(id: 4)
    shirt_array = 
    {
      name: shirt.name,
      size: shirt.size,
      price: shirt.price,
      image_url: shirt.image_url,
      description: shirt.description
    }

    render json: shirt_array.as_json
  end

  def shirt1_xl
    shirt = Product.find_by(id: 5)
    shirt_array = 
    {
      name: shirt.name,
      size: shirt.size,
      price: shirt.price,
      image_url: shirt.image_url,
      description: shirt.description
    }

    render json: shirt_array.as_json
  end

  def shirt2_sm
    shirt = Product.find_by(id: 6)
    shirt_array = 
    {
      name: shirt.name,
      size: shirt.size,
      price: shirt.price,
      image_url: shirt.image_url,
      description: shirt.description
    }

    render json: shirt_array.as_json
  end

  def shirt2_md
    shirt = Product.find_by(id: 7)
    shirt_array = 
    {
      name: shirt.name,
      size: shirt.size,
      price: shirt.price,
      image_url: shirt.image_url,
      description: shirt.description
    }

    render json: shirt_array.as_json
  end

  def shirt2_lg
    shirt = Product.find_by(id: 8)
    shirt_array = 
    {
      name: shirt.name,
      size: shirt.size,
      price: shirt.price,
      image_url: shirt.image_url,
      description: shirt.description
    }

    render json: shirt_array.as_json
  end 

end
