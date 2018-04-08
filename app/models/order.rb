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

end
