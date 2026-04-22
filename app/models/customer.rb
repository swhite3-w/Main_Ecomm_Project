class Customer < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  belongs_to :province
  has_many :orders, dependent: :destroy

  validates :full_name, presence: true
  validates :email, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    ["created_at", "email", "full_name", "id", "province_id", "updated_at"]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["orders", "province"]
  end
end