class Customer < ApplicationRecord
  belongs_to :province
  has_many :orders, dependent: :destroy

  validates :full_name, presence: true
  validates :email, presence: true
end