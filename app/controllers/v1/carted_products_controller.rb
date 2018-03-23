class V1::CartedProductsController < ApplicationController
  def index
    cartedproducts = current_user.carted_products.where("status = 'carted'")
    quantities = cartedproducts.map {|product| product[:quantity] }
    cartedproducts = cartedproducts.map {|product| Product.find_by(id: product[:product_id]) }
    cartedproducts = cartedproducts.map {|product| "Name: #{product[:name]}, Quantity: #{quantities}" }

    render json: cartedproducts.as_json
  end

  def create
    id = params[:id]
    quantity = params[:quantity]
    product = Product.find_by(id: id)

    cartedproduct = CartedProduct.new(
      {
        user_id: current_user.id,
        product_id: id,
        quantity: quantity,
        status: "carted",
        order_id: nil
      }
    )

    if cartedproduct.save
      render json: cartedproduct.as_json
    else
      render json: {message: "There were issues with your order. Please try again."}, status: :bad_request
    end
  end
end
