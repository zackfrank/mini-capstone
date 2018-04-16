class V1::ProductsController < ApplicationController
  before_action :authenticate_admin, except: [:index, :show]

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
      in_stock: params["in_stock"],
      supplier_id: params["supplier_id"]
      )

    if product.save
      image = Image.new(
        url: "http://allpicts.in/wp-content/uploads/2017/02/blank-tshirt-template-front-back-side-1024x576.jpg",
        product_id: product.id
      )
      image.save
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
    product.supplier_id = params["supplier_id"] || product.supplier_id

    if product.save
      render json: product.as_json
    else
      render json: {errors: product.errors.full_messages}, status: 422
    end
  end

  def destroy
 
    product = Product.find_by(id: params["id"])
    

    if product.destroy
      render json: {message: "Product successfully deleted."}
    else
      render json: {}, status: :unauthorized
    end
  end

end
