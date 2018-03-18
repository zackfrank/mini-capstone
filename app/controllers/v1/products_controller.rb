class V1::ProductsController < ApplicationController
  
  def index
    products = Product.all

    order_by = params["order_by"]
    products = products.order("#{order_by}")

    search = params[:search]

    if search
      render json: products.where(
        "name ILIKE ? 
        OR size ILIKE ? 
        OR description ILIKE ?", 
        "%#{search}%", 
        "%#{search}%", 
        "%#{search}%").as_json
    else
      render json: products.as_json
    end
  end

  def show
    id = params["id"].to_i
    product = Product.find_by(id: id)
    render json: product.as_json
  end

  def create
    product = Product.new(
      name: params["name"], 
      size: params["size"],
      price: params["price"], 
      description: params["description"],
      in_stock: params["in_stock"]
      )

    if product.save
      render json: product.as_json
    else
      render json: {errors: product.errors.full_messages}, status: 422
    end

  end

  def update
    product = Product.find_by(id: params["id"])
    product.name = params["name"] || product.name
    product.size = params["size"] || product.size
    product.price = params["price"] || product.price
    product.description = params["description"] || product.description
    product.in_stock = params["in_stock"] || product.in_stock
    product.supplier.name = params["supplier"] || product.supplier.name

    if product.save
      render json: product.as_json
    else
      render json: {errors: product.errors.full_messages}, status: 422
    end

  end

  def destroy
    product = Product.find_by(id: params["id"])
    product.destroy

    render json: {message: "Product successfully deleted."}
  end

end
