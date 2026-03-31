class Product < ApplicationRecord
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :image_url, presence: true
  validates :category, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "id", "image_url", "is_active", "is_featured", "price", "stock_quantity", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end
end