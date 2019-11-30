require 'rails_helper'

describe "Invoices API" do
  it 'can return a list of invoices' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    Invoice.create!(status: 'shipped', customer_id: pam.id, merchant_id: bob.id)
    Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: johnny.id)
    Invoice.create!(status: 'shipped', customer_id: pam.id, merchant_id: johnny.id)

    get '/api/v1/invoices'

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices["data"].count).to eq(4)
  end

  it 'can get one invoice by its id' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: pam.id, merchant_id: bob.id)

    get "/api/v1/invoices/#{inv_1.id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"]).to eq(inv_1.id.to_s)
    expect(invoice["data"]["attributes"]["customer_id"]).to eq(michael.id)
  end

  it 'can find an invoice by status' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'packaged', customer_id: pam.id, merchant_id: bob.id)

    get "/api/v1/invoices/find?status=shipped"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"]).to eq(inv_1.id.to_s)
    expect(invoice["data"]["attributes"]["customer_id"]).to eq(michael.id)
  end

  it 'can find an invoice by date' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id, created_at: "Thurs, 21 Nov 2019 18:49:17 UTC +00:00")
    inv_2 = Invoice.create!(status: 'packaged', customer_id: pam.id, merchant_id: bob.id)

    get "/api/v1/invoices/find?created_at=#{inv_1.created_at}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"]).to eq(inv_1.id.to_s)
    expect(invoice["data"]["attributes"]["customer_id"]).to eq(michael.id)
  end

  it 'can find an invoice by customer id' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'packaged', customer_id: pam.id, merchant_id: bob.id)

    get "/api/v1/invoices/find?customer_id=#{michael.id}"

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["id"]).to eq(inv_1.id.to_s)
    expect(invoice["data"]["attributes"]["customer_id"]).to eq(michael.id)
  end

  it 'can find all invoices by a given parameter' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'packaged', customer_id: pam.id, merchant_id: bob.id)

    get "/api/v1/invoices/find_all?merchant_id=#{bob.id}"

    invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoices["data"].kind_of?(Array)).to eq(true)
    expect(invoices["data"].count).to eq(2)
    expect(invoices["data"].first["id"]).to eq(inv_1.id.to_s)
    expect(invoices["data"].last["id"]).to eq(inv_2.id.to_s)
  end

  it 'can return a random invoice' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'packaged', customer_id: michael.id, merchant_id: bob.id)

    get '/api/v1/invoices/random'

    invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice["data"]["type"]).to eq("invoice")
  end
end
