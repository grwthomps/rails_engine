require 'rails_helper'

describe 'Invoices API - Relationship Endpoints' do
  it 'can return a collection of associated transactions' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    dwight = Customer.create!(first_name: "Dwight", last_name: "Schrute")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: dwight.id, merchant_id: bob.id)

    trans_1 = Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success', invoice_id: inv_1.id)
    trans_2 = Transaction.create!(credit_card_number: 4580251236515201, credit_card_expiration_date: '', result: 'success', invoice_id: inv_1.id)
    trans_3 = Transaction.create!(credit_card_number: 4354495077693036, credit_card_expiration_date: '', result: 'success', invoice_id: inv_1.id)
    trans_4 = Transaction.create!(credit_card_number: 4354495077693036, credit_card_expiration_date: '', result: 'success', invoice_id: inv_2.id)

    get "/api/v1/invoices/#{inv_1.id}/transactions"

    invoice_transactions = JSON.parse(response.body)

    expect(invoice_transactions["data"].count).to eq(3)
    expect(invoice_transactions["data"].first["id"]).to eq(trans_1.id.to_s)
    expect(invoice_transactions["data"].last["id"]).to eq(trans_3.id.to_s)
    expect(invoice_transactions["data"].any? {|h| h["id"] == "#{trans_4.id}"}).to eq(false)
  end

  it 'can return a collection of associated invoice items' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    boston_creme = Item.create!(name: 'Boston Creme', description: "An instant classic", unit_price: 200, merchant_id: bob.id)

    inv_item_1 = InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)
    inv_item_2 = InvoiceItem.create!(item_id: boston_creme.id, invoice_id: inv_1.id, quantity: 2, unit_price: 200)

    get "/api/v1/invoices/#{inv_1.id}/invoice_items"

    invoice_items = JSON.parse(response.body)

    expect(invoice_items["data"].count).to eq(2)
    expect(invoice_items["data"].first["id"]).to eq(inv_item_1.id.to_s)
    expect(invoice_items["data"].last["id"]).to eq(inv_item_2.id.to_s)
  end

  it 'can return a collection of associated items' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    boston_creme = Item.create!(name: 'Boston Creme', description: "An instant classic", unit_price: 200, merchant_id: bob.id)
    jelly_filled = Item.create!(name: 'Jelly Filled', description: "Has jelly", unit_price: 200, merchant_id: bob.id)

    inv_item_1 = InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)
    inv_item_2 = InvoiceItem.create!(item_id: boston_creme.id, invoice_id: inv_1.id, quantity: 2, unit_price: 200)

    get "/api/v1/invoices/#{inv_1.id}/items"

    items = JSON.parse(response.body)

    expect(items["data"].count).to eq(2)
    expect(items["data"].first["id"]).to eq(glazed.id.to_s)
    expect(items["data"].last["id"]).to eq(boston_creme.id.to_s)
    expect(items["data"].any? {|h| h["id"] == "#{jelly_filled.id}"}).to eq(false)
  end

  it 'can return the associated customer' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    get "/api/v1/invoices/#{inv_1.id}/customer"

    invoice_customer = JSON.parse(response.body)

    expect(invoice_customer["data"]["type"]).to eq("customer")
    expect(invoice_customer["data"]["attributes"]["id"]).to eq(michael.id)
  end

  it 'can return the associated merchant' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    get "/api/v1/invoices/#{inv_1.id}/merchant"

    invoice_merchant = JSON.parse(response.body)

    expect(invoice_merchant["data"]["type"]).to eq("merchant")
    expect(invoice_merchant["data"]["attributes"]["id"]).to eq(bob.id)
  end
end
