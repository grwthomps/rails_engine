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

  it 'can find a customer by first name' do
    michael = Customer.create(first_name: "Michael", last_name: "Scott")
    dwight = Customer.create(first_name: "Dwight", last_name: "Schrute")

    get '/api/v1/customers/find?first_name=Michael'

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq(michael.id.to_s)
    expect(customer["data"]["attributes"]["first_name"]).to eq(michael.first_name)
  end

  it 'can find a customer by last name' do
    michael = Customer.create(first_name: "Michael", last_name: "Scott")
    dwight = Customer.create(first_name: "Dwight", last_name: "Schrute")

    get '/api/v1/customers/find?last_name=Schrute'

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq(dwight.id.to_s)
    expect(customer["data"]["attributes"]["last_name"]).to eq(dwight.last_name)
  end

  it 'can find a customer by date' do
    michael = Customer.create(first_name: "Michael", last_name: "Scott", created_at: "Thurs, 21 Nov 2019 18:49:17 UTC +00:00")
    dwight = Customer.create(first_name: "Dwight", last_name: "Schrute")

    get "/api/v1/customers/find?created_at=#{michael.created_at}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["id"]).to eq(michael.id.to_s)
  end

  it 'can find all customers by a given parameter' do
    michael = Customer.create(first_name: "Michael", last_name: "Scott", created_at: "Thurs, 21 Nov 2019 18:49:17 UTC +00:00")
    dwight = Customer.create(first_name: "Dwight", last_name: "Schrute", created_at: "Thurs, 21 Nov 2019 18:49:17 UTC +00:00")

    get "/api/v1/customers/find_all?created_at=#{michael.created_at}"

    customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customers["data"].kind_of?(Array)).to eq(true)
    expect(customers["data"].count).to eq(2)
    expect(customers["data"].first["id"]).to eq(michael.id.to_s)
    expect(customers["data"].last["id"]).to eq(dwight.id.to_s)
  end
end
