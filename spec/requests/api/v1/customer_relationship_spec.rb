require 'rails_helper'

describe 'Customer API - Relationship Endpoints' do
  it 'can return a collection of associated invoices' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: johnny.id)

    get "/api/v1/customers/#{michael.id}/invoices"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices["data"].kind_of?(Array)).to eq(true)
    expect(invoices["data"].count).to eq(2)
    expect(invoices["data"].first["id"]).to eq(inv_1.id.to_s)
    expect(invoices["data"].last["id"]).to eq(inv_2.id.to_s)
  end

  it 'can return a collection of associated transactions' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: johnny.id)

    trans_1 = Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success', invoice_id: inv_1.id)
    trans_2 = Transaction.create!(credit_card_number: 4580251236515201, credit_card_expiration_date: '', result: 'success', invoice_id: inv_1.id)
    trans_3 = Transaction.create!(credit_card_number: 4354495077693036, credit_card_expiration_date: '', result: 'success', invoice_id: inv_2.id)

    get "/api/v1/customers/#{michael.id}/transactions"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions["data"].kind_of?(Array)).to eq(true)
    expect(transactions["data"].count).to eq(3)
    expect(transactions["data"].first["id"]).to eq(trans_1.id.to_s)
    expect(transactions["data"].last["id"]).to eq(trans_3.id.to_s)
  end
end
