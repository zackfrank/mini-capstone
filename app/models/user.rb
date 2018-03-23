class User < ApplicationRecord
  has_secure_password
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :orders
  has_many :carted_products


  def as_json
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      admin: admin
    }
  end
end
