class V1::OrdersController < ApplicationController
 
  def index
    if current_user
      orders = current_user.orders
      render json: orders.as_json
    else
      render json: {message: "Please log in to view this page."}
    end
  end


  def create
    if current_user
      product_id = params[:product_id].to_i
      subtotal = params[:quantity].to_i * Product.find_by(id: product_id).price
      tax = subtotal * 1.09
      total = subtotal + tax

      order = Order.new(
        user_id: current_user.id,
        product_id: product_id, 
        quantity: params[:quantity],
        subtotal: subtotal,
        tax: tax,
        total: total
        )

      if order.save
        render json: {
          message: "Order Succesful!",
          order: order
        }
      else
        render json: {message: order.errors.full_messages}, status: :bad_request
      end
    else
      render json: {message: "You are not logged in. Please login or sign up"}
    end
  end

end
