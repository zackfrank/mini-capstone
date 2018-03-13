class Product < ApplicationRecord

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

  def as_json
    {
      id: id,
      name: name,
      size: size, 
      price: "$#{price}",
      is_discounted: is_discounted,
      tax: "$#{tax}", 
      total: "$#{total}",
      image_url: image_url,
      description: description,
      created_at: friendly_created_at, 
      updated_at: friendly_updated_at
    }
  end

end
