require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :unit_price}
    it {should validate_numericality_of :unit_price}
  end

  describe 'relationships' do
    it {should belong_to :invoice}
    it {should belong_to :item}
  end

  describe 'instance methods' do
    it 'converts unit price to dollars' do
      merch = Merchant.create!(name: "Bob's Donuts")
      item = Item.create!(name: "Jelly filled donut", description: "It's got jelly!", unit_price: 75901, merchant_id: merch.id)
      cust = Customer.create!(first_name: "Joe", last_name: "Smith")
      inv = Invoice.create!(customer_id: cust.id, merchant_id: merch.id, status: "shipped")
      InvoiceItem.create!(item_id: item.id, invoice_id: inv.id, quantity: 5, unit_price: 13635)

      expect(InvoiceItem.last.unit_price).to eq(136.35)
    end
  end
end
