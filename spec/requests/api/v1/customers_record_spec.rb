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
end
