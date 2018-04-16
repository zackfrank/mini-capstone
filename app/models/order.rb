class Order < ApplicationRecord
  belongs_to :user
  has_many :carted_products
  has_many :products, through: :carted_products


  def update_totals
    subtotal = carted_products.map {|carted_product| carted_product.product.price * carted_product.quantity}.reduce(:+)
    # puts "-" * 50
    # p subtotal
    # puts "-" * 50
    # subtotal = subtotal.to_f
    # puts "-" * 50
    # p subtotal
    # puts "-" * 50
    tax = subtotal * 0.09
    total = subtotal + tax
    self.subtotal = subtotal
    self.tax = tax
    self.total = total
  end

  def as_json
    carted_products = CartedProduct.where(order_id: self.id)
    user = User.find_by(id: user_id)
    {
      order_id: id,
      customer: user.first_name + " " + user.last_name,
      items: carted_products.map {|cp| {product: Product.find_by(id: cp.product_id).name, img_url: Image.find_by(product_id: cp.product_id).url, quantity: cp.quantity } },
      subtotal: subtotal,
      tax: tax,
      total: total
    }
  end

end
