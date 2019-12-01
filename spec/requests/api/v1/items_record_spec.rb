require 'rails_helper'

describe 'Items API' do
  it 'can return a list of items' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    get '/api/v1/items'

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].count).to eq(2)
  end

  it 'can get one item by its id' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    donut = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    get "/api/v1/items/#{donut.id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"]).to eq(donut.id.to_s)
    expect(item["data"]["attributes"]["merchant_id"]).to eq(bob.id)
  end

  it 'can find an item by name' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    donut = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    get "/api/v1/items/find?name=Black Lab"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"]).to eq(lab.id.to_s)
    expect(item["data"]["attributes"]["name"]).to eq(lab.name)
  end

  it 'can find an item by description' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    donut = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    get "/api/v1/items/find?description=Truly the best pupper"

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["id"]).to eq(lab.id.to_s)
    expect(item["data"]["attributes"]["name"]).to eq(lab.name)
  end

  it 'can find an item by unit price' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    donut = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    get "/api/v1/items/find?unit_price=100"

    item = JSON.parse(response.body)

    binding.pry

    expect(response).to be_successful
    expect(item["data"]["id"]).to eq(lab.id.to_s)
    expect(item["data"]["attributes"]["name"]).to eq(lab.name)
  end

  it 'can find all items by a given parameter' do
    bob = Merchant.create!(name: "Bob's Donuts")

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    boston_creme = Item.create!(name: 'Boston Creme', description: "An instant classic!", unit_price: 200, merchant_id: bob.id)

    get "/api/v1/items/find_all?merchant_id=#{bob.id}"

    items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(items["data"].kind_of?(Array)).to eq(true)
    expect(items["data"].count).to eq(2)
    expect(items["data"].first["id"]).to eq(glazed.id.to_s)
    expect(items["data"].last["id"]).to eq(boston_creme.id.to_s)
  end

  it 'can return a random item' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    donut = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    get '/api/v1/items/random'

    item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(item["data"]["type"]).to eq("item")
  end
end
