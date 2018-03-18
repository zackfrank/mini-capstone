class Image < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true
  validates :descriptio, presence: true
end
