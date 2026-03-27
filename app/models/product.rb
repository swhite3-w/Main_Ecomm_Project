class Product < ApplicationRecord
  belongs_to :category

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "id", "image_url", "is_active", "is_featured", "price", "stock_quantity", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end
end