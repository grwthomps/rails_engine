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

end
