require 'rails_helper'

describe 'Items API - Relationship Endpoints' do
  it 'can return a collection of associated invoice items' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    dwight = Customer.create!(first_name: "Dwight", last_name: "Schrute")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: dwight.id, merchant_id: bob.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)

    inv_item_1 = InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)
    inv_item_2 = InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_2.id, quantity: 5, unit_price: 200)

    get "/api/v1/items/#{glazed.id}/invoice_items"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_items["data"].kind_of?(Array)).to eq(true)
    expect(invoice_items["data"].count).to eq(2)
    expect(invoice_items["data"].first["id"]).to eq(inv_item_1.id.to_s)
    expect(invoice_items["data"].last["id"]).to eq(inv_item_2.id.to_s)
  end

  it 'can return an associated merchant' do
    bob = Merchant.create!(name: "Bob's Donuts")

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)

    get "/api/v1/items/#{glazed.id}/merchant"

    merchant = JSON.parse(response.body)

    expect(merchant["data"]["type"]).to eq("merchant")
    expect(merchant["data"]["attributes"]["id"]).to eq(bob.id)
  end
end
