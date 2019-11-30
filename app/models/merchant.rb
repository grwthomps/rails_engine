class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.highest_total_revenue(quantity)
    joins(:invoice_items, :transactions)
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:id)
    .where(transactions: {result: 'success'})
    .order("revenue desc")
    .limit(quantity)
  end
end
