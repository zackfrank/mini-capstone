class Category < ApplicationRecord
  has_many :category_products
  has_many :products, through: :category_products

  def as_json
    {
      name: name,
      products: products.map { |product| product.name }
    }
  end
end
