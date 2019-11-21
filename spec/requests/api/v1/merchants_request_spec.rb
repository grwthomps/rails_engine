require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    Merchant.create(name: "Bob's Donuts")
    Merchant.create(name: "Jenny's Fabulous Flowers")
    Merchant.create(name: "Johnny's Pet Store")

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    expect(merchants["data"].count).to eq(3)
  end

  it 'can get one merchant by its id' do
    bob = Merchant.create(name: "Bob's Donuts")
    jenny = Merchant.create(name: "Jenny's Fabulous Flowers")

    get "/api/v1/merchants/#{bob.id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(bob.id.to_s)
  end

  it 'can find a merchant by name' do
    bob = Merchant.create(name: "Bob's Donuts")
    jenny = Merchant.create(name: "Jenny's Fabulous Flowers")

    get '/api/v1/merchants/find?name=Bob%27s%20Donuts'

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(bob.id.to_s)
    expect(merchant["data"]["attributes"]["name"]).to eq(bob.name)
  end

  it 'can find a merchant by date' do
    bob = Merchant.create(name: "Bob's Donuts")
    jenny = Merchant.create(name: "Jenny's Fabulous Flowers", created_at: "Thurs, 21 Nov 2019 18:49:17 UTC +00:00")

    get "/api/v1/merchants/find?created_at=#{jenny.created_at}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["id"]).to eq(jenny.id.to_s)
  end

  it 'can find all merchants by a given parameter' do
    bob = Merchant.create(name: "Bob's Donuts", created_at: "Thurs, 21 Nov 2019 18:49:17 UTC +00:00")
    jenny = Merchant.create(name: "Jenny's Fabulous Flowers", created_at: "Thurs, 21 Nov 2019 18:49:17 UTC +00:00")

    get "/api/v1/merchants/find_all?created_at=#{bob.created_at}"

    merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchants["data"].kind_of?(Array)).to eq(true)
    expect(merchants["data"].count).to eq(2)
    expect(merchants["data"].first["id"]).to eq(bob.id.to_s)
  end

  it 'can return a random merchant' do
    Merchant.create(name: "Bob's Donuts")
    Merchant.create(name: "Jenny's Fabulous Flowers")
    Merchant.create(name: "Johnny's Pet Store")

    get '/api/v1/merchants/random'

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["type"]).to eq("merchant")
  end
end
