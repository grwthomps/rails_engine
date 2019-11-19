require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :unit_price}
    it {should validate_numericality_of :unit_price}
  end

  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
  end

  describe 'instance methods' do
    it 'converts unit price to dollars' do
      bob = Merchant.create!(name: "Bob's Donuts")
      Item.create!(name: "Jelly filled donut", description: "It's got jelly!", unit_price: 75901, merchant_id: bob.id)

      expect(Item.last.unit_price).to eq(759.01)
    end
  end
end
