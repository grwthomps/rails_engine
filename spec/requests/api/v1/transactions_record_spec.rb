require 'rails_helper'

describe 'Transactions API' do
  it 'can return a list of transactions' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    Transaction.create!(credit_card_number: 4580251236515201, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    Transaction.create!(credit_card_number: 4354495077693036, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)

    get '/api/v1/transactions'

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions["data"].count).to eq(3)
  end

  it 'can get one transaction by its id' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    trans_1 = Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    Transaction.create!(credit_card_number: 4580251236515201, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    Transaction.create!(credit_card_number: 4354495077693036, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)

    get "/api/v1/transactions/#{trans_1.id}"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["id"]).to eq(trans_1.id.to_s)
    expect(transaction["data"]["attributes"]["credit_card_number"]).to eq(trans_1.credit_card_number)
  end

  it 'can find a transaction by credit card number' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    trans_1 = Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    Transaction.create!(credit_card_number: 4580251236515201, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    Transaction.create!(credit_card_number: 4354495077693036, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)

    get "/api/v1/transactions/find?credit_card_number=4654405418249632"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["id"]).to eq(trans_1.id.to_s)
    expect(transaction["data"]["attributes"]["credit_card_number"]).to eq(trans_1.credit_card_number)
  end

  it 'can find a transaction by result' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    trans_1 = Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    Transaction.create!(credit_card_number: 4580251236515201, credit_card_expiration_date: '', result: 'failed', invoice_id: inv.id)
    Transaction.create!(credit_card_number: 4354495077693036, credit_card_expiration_date: '', result: 'failed', invoice_id: inv.id)

    get "/api/v1/transactions/find?result=success"

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["id"]).to eq(trans_1.id.to_s)
    expect(transaction["data"]["attributes"]["result"]).to eq('success')
  end

  it 'can find all items by a given parameter' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    trans_1 = Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    trans_2 = Transaction.create!(credit_card_number: 4580251236515201, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    trans_3 = Transaction.create!(credit_card_number: 4354495077693036, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)

    get "/api/v1/transactions/find_all?result=success"

    transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transactions["data"].kind_of?(Array)).to eq(true)
    expect(transactions["data"].count).to eq(3)
    expect(transactions["data"].first["id"]).to eq(trans_1.id.to_s)
    expect(transactions["data"].last["id"]).to eq(trans_3.id.to_s)
  end

  it 'can return a random item' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    trans_1 = Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    trans_2 = Transaction.create!(credit_card_number: 4580251236515201, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)
    trans_3 = Transaction.create!(credit_card_number: 4354495077693036, credit_card_expiration_date: '', result: 'success', invoice_id: inv.id)

    get '/api/v1/transactions/random'

    transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(transaction["data"]["type"]).to eq("transaction")
  end
end
