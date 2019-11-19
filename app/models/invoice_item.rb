class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity, :unit_price
  validates_numericality_of :unit_price, only_integer: true

  belongs_to :item
  belongs_to :invoice

end
