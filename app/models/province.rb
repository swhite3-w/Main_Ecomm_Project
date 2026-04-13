class Province < ApplicationRecord
  has_many :customers, dependent: :nullify

  validates :name, presence: true
  validates :code, presence: true
  validates :gst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :pst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :hst_rate, presence: true, numericality: { greater_than_or_equal_to: 0 }
end