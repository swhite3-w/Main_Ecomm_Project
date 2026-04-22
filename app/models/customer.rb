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
end