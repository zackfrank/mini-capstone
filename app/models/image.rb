class Image < ApplicationRecord
  validates :title, presence: true
  validates :url, presence: true
  validates :description, presence: true
end
