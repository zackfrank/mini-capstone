class CartedProduct < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :user

  def carted_status # not sure if I could use this
    carted_array = current_user.carted_products.where("status = 'carted'")
  end

  def as_json
    product = Product.find_by(id: product_id)
    {  
      cart_id: id,
      product_id: product_id,
      name: product.name, 
      price: product.price, 
      quantity: quantity
    }
  end

end
