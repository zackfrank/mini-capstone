class V1::OrdersController < ApplicationController
  before_action :authenticate_user
 
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
      carted_products = current_user.carted_products.where("status = 'carted'")
      subtotal = carted_products.map {|carted_product| carted_product.product.price * carted_product.quantity}.reduce(:+)
      tax = subtotal * 0.09
      total = subtotal + tax

      order = Order.new(user_id: current_user.id,
      # order.update_totals
        subtotal: subtotal,
        tax: tax,
        total: total
        )

      if order.save
        carted_products.update_all(status: 'purchased', order_id: "#{order.id}")
        render json: {
          message: "Order Succesful!",
          order: order.as_json
        }
      else
        render json: {message: order.errors.full_messages}, status: :bad_request
      end
    else
      render json: {message: "You are not logged in. Please log in or sign up"}
    end
  end

end
