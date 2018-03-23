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
      ids_prices_qty = carted_products.map {|item| {product_id: item[:product_id], price: Product.find_by(id: item[:product_id]).price, quantity: item[:quantity]}}
      subtotal = ids_prices_qty.map {|each| each[:price] * each[:quantity]}.reduce(:+)
      tax = subtotal * 0.09
      total = subtotal + tax

      order = Order.new(
        user_id: current_user.id,
        subtotal: subtotal,
        tax: tax,
        total: total
        )

      if order.save
        carted_products.each do |cp|
          cp[:status] = "purchased"
          cp[:order_id] = order.id
          cp.save
        end
        render json: {
          message: "Order Succesful!",
          order: order.as_json
        }
      else
        render json: {message: order.errors.full_messages}, status: :bad_request
      end
    else
      render json: {message: "You are not logged in. Please login or sign up"}
    end
  end

end
