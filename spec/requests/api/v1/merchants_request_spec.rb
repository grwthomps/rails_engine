require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    Merchant.create(name: "Bob's Donuts")
    Merchant.create(name: "Jenny's Fabulous Flowers")
    Merchant.create(name: "Johnny's Pet Store")

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants.count).to eq(3)
  end
end
