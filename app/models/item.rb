class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price
  validates_numericality_of :unit_price, only_integer: true

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  before_save :convert_unit_price

  def convert_unit_price
    self.unit_price /= 100
  end
end
