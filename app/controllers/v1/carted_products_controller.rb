class V1::CartedProductsController < ApplicationController
  def index
    carted_items = current_user.carted_products.select {|item| item[:status] == "carted"}
    ids_name_qty = carted_items.map do |item| 
      {
      cart_id: item[:id],
      product_id: item[:product_id], 
      name: Product.find_by(id: item[:product_id]).name, 
      quantity: item[:quantity]
      }
    end
    # names_and_quantities = id_and_quantity.map {|item| {name: Product.find_by(id: item[:product_id]).name, quantity: item[:quantity]} }

    render json: ids_name_qty.as_json
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
        status: "carted"
      }
    )

    if cartedproduct.save
      render json: cartedproduct.as_json
    else
      render json: {message: "There were issues adding item(s) to your cart. Please try again."}, status: :bad_request
    end
  end

  def destroy
    cartedproduct = CartedProduct.find_by(id: params[:id])
    cartedproduct[:status] = "removed"

    if cartedproduct.save
      render json: {message: "Product removed from cart."}
    else
      render json: {message: "There was an error. Item could not be removed from cart. Please call Jay Wengrow."}
    end
  end

end
