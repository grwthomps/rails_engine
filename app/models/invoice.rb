class Invoice < ApplicationRecord
  validates_presence_of :status

  belongs_to :customer
  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :items, through: :invoice_items

  has_many :transactions

  def self.total_revenue_on_date(date)
    joins(:invoice_items, :transactions)
    .where("result = 'success'")
    .where(created_at: date.to_date.all_day)
    .sum('quantity * unit_price')
  end
end
