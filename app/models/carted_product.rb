class CartedProduct < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :user

  def carted_status # not sure if I could use this
    carted_array = current_user.carted_products.where("status = 'carted'")
  end
end
