require 'rails_helper'

describe 'Transactions API - Relationship Endpoints' do
  it 'can return an associated invoice' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    trans = Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)

    get "/api/v1/transactions/#{trans.id}/invoice"

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["type"]).to eq("invoice")
    expect(invoice["data"]["attributes"]["id"]).to eq(inv.id)
  end
end
