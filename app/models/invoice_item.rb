class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity, :unit_price
  validates_numericality_of :unit_price, only_integer: true

  belongs_to :item
  belongs_to :invoice

  before_save :convert_unit_price

  def convert_unit_price
    self.unit_price /= 100
  end
end
