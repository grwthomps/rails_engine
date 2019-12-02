require 'rails_helper'

describe 'Invoice Items API - Relationship Endpoints' do
  it 'can return an associated invoice' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)

    inv_item = InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)

    get "/api/v1/invoice_items/#{inv_item.id}/invoice"

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["type"]).to eq("invoice")
    expect(invoice["data"]["attributes"]["id"]).to eq(inv_1.id)
  end

  it 'can return an associated item' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)

    inv_item = InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)

    get "/api/v1/invoice_items/#{inv_item.id}/item"

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["type"]).to eq("item")
    expect(invoice["data"]["attributes"]["id"]).to eq(glazed.id)
  end
end
