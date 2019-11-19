class Invoice < ApplicationRecord
  validates_presence_of :status

  belongs_to :customer
  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  has_many :transactions
end