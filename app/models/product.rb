class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :description, length: {in: 10..500}

  def is_discounted
    price <= 2
  end

  def tax
    tax = price * 0.09
    return tax.to_d
  end

  def total
    price + tax
  end

  def friendly_created_at
    created_at.strftime("%A, %B %e %l:%m %p")
  end

  def friendly_updated_at
    updated_at.strftime("%A, %B %e %l:%m %p")
  end

  # def supplier
  #   Supplier.find_by(id: supplier_id)
  # end
  belongs_to :supplier

  # def images
  #   Image.where(product_id: id).map { |image| {description: image.description, url: image.url}}
  # end
  has_many :images


  def as_json
    {
      id: id,
      name: name,
      size: size, 
      price: "$#{price}",
      is_discounted: is_discounted,
      tax: "$#{tax}", 
      total: "$#{total}",
      description: description,
      in_stock: in_stock,
      images: images.map { |image| {description: image.description, url: image.url}},
      created_at: friendly_created_at, 
      updated_at: friendly_updated_at,
      supplier: supplier.as_json
    }
  end

end
