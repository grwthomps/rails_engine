require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of customers' do
    Customer.create(first_name: "Michael", last_name: "Scott")
    Customer.create(first_name: "Pam", last_name: "Beesly")
    Customer.create(first_name: "Dwight", last_name: "Schrute")

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)
    expect(customers["data"].count).to eq(3)
  end

  it 'can get one customer by its id' do
    michael = Customer.create(first_name: "Michael", last_name: "Scott")
    dwight = Customer.create(first_name: "Dwight", last_name: "Schrute")

    get "/api/v1/customers/#{dwight.id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq(dwight.id.to_s)
  end
end
