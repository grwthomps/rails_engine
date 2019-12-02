require 'rails_helper'

describe 'Invoice Items API' do
  it 'sends a list of invoice items' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: pam.id, merchant_id: johnny.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    boston_creme = Item.create!(name: 'Boston Creme', description: "An instant classic", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)
    InvoiceItem.create!(item_id: boston_creme.id, invoice_id: inv_1.id, quantity: 2, unit_price: 200)
    InvoiceItem.create!(item_id: lab.id, invoice_id: inv_2.id, quantity: 1, unit_price: 10000)

    get '/api/v1/invoice_items'

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)
    expect(invoice_items["data"].count).to eq(3)
  end

  it 'can get one invoice item by its id' do
    bob = Merchant.create!(name: "Bob's Donuts")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    boston_creme = Item.create!(name: 'Boston Creme', description: "An instant classic", unit_price: 200, merchant_id: bob.id)

    inv_item = InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)
    InvoiceItem.create!(item_id: boston_creme.id, invoice_id: inv_1.id, quantity: 2, unit_price: 200)

    get "/api/v1/invoice_items/#{inv_item.id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["id"]).to eq(inv_item.id.to_s)
  end

  it 'can find an invoice item by invoice id' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: pam.id, merchant_id: johnny.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    boston_creme = Item.create!(name: 'Boston Creme', description: "An instant classic", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)
    InvoiceItem.create!(item_id: boston_creme.id, invoice_id: inv_1.id, quantity: 2, unit_price: 200)
    inv_item = InvoiceItem.create!(item_id: lab.id, invoice_id: inv_2.id, quantity: 1, unit_price: 10000)

    get "/api/v1/invoice_items/find?invoice_id=#{inv_2.id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["id"]).to eq(inv_item.id.to_s)
    expect(invoice_item["data"]["attributes"]["item_id"]).to eq(lab.id)
  end

  it 'can find an invoice item by item id' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: pam.id, merchant_id: johnny.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    boston_creme = Item.create!(name: 'Boston Creme', description: "An instant classic", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    inv_item = InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)
    InvoiceItem.create!(item_id: boston_creme.id, invoice_id: inv_1.id, quantity: 2, unit_price: 200)
    InvoiceItem.create!(item_id: lab.id, invoice_id: inv_2.id, quantity: 1, unit_price: 10000)

    get "/api/v1/invoice_items/find?item_id=#{glazed.id}"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["id"]).to eq(inv_item.id.to_s)
    expect(invoice_item["data"]["attributes"]["invoice_id"]).to eq(inv_1.id)
  end

  it 'can find an invoice item by unit price' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: pam.id, merchant_id: johnny.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    boston_creme = Item.create!(name: 'Boston Creme', description: "An instant classic", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    inv_item = InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)
    InvoiceItem.create!(item_id: boston_creme.id, invoice_id: inv_1.id, quantity: 2, unit_price: 200)
    InvoiceItem.create!(item_id: lab.id, invoice_id: inv_2.id, quantity: 1, unit_price: 10000)

    get "/api/v1/invoice_items/find?unit_price=2"

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["id"]).to eq(inv_item.id.to_s)
  end

  it 'can find all invoice items by a given parameter' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: pam.id, merchant_id: johnny.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    boston_creme = Item.create!(name: 'Boston Creme', description: "An instant classic", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    inv_item_1 = InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 1, unit_price: 200)
    inv_item_2 = InvoiceItem.create!(item_id: boston_creme.id, invoice_id: inv_1.id, quantity: 1, unit_price: 200)
    inv_item_3 = InvoiceItem.create!(item_id: lab.id, invoice_id: inv_2.id, quantity: 1, unit_price: 10000)

    get "/api/v1/invoice_items/find_all?quantity=1"

    invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_items["data"].kind_of?(Array)).to eq(true)
    expect(invoice_items["data"].count).to eq(3)
    expect(invoice_items["data"].first["id"]).to eq(inv_item_1.id.to_s)
    expect(invoice_items["data"].last["id"]).to eq(inv_item_3.id.to_s)
  end

  it 'can return a random invoice item' do
    bob = Merchant.create!(name: "Bob's Donuts")
    johnny = Merchant.create!(name: "Johnny's Pet Store")

    michael = Customer.create!(first_name: "Michael", last_name: "Scott")
    pam = Customer.create!(first_name: "Pam", last_name: "Beesly")

    inv_1 = Invoice.create!(status: 'shipped', customer_id: michael.id, merchant_id: bob.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: pam.id, merchant_id: johnny.id)

    glazed = Item.create!(name: 'Glazed Donut', description: "It\'s delicious!", unit_price: 200, merchant_id: bob.id)
    boston_creme = Item.create!(name: 'Boston Creme', description: "An instant classic", unit_price: 200, merchant_id: bob.id)
    lab = Item.create!(name: 'Black Lab', description: 'Truly the best pupper', unit_price: 10000, merchant_id: johnny.id)

    InvoiceItem.create!(item_id: glazed.id, invoice_id: inv_1.id, quantity: 3, unit_price: 200)
    InvoiceItem.create!(item_id: boston_creme.id, invoice_id: inv_1.id, quantity: 2, unit_price: 200)
    InvoiceItem.create!(item_id: lab.id, invoice_id: inv_2.id, quantity: 1, unit_price: 10000)

    get '/api/v1/invoice_items/random'

    invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(invoice_item["data"]["type"]).to eq("invoice_item")
  end
end
