require 'rails_helper'

describe 'Merchants API - Business Intelligence Endpoints' do
  it 'can return top merchants ranked by total revenue' do
    andy = Merchant.create!(name: "Andy's Ice Cream Shop")
    april = Merchant.create!(name: "April's Morbid Curiosities")
    tom = Merchant.create!(name: "Tom's Luxurious Suits")
    leslie = Merchant.create!(name: "Leslie's Waffle House")

    cust_1 = Customer.create!(first_name: "George", last_name: "Wilbur")
    cust_2 = Customer.create!(first_name: "Sally", last_name: "Chesterfield")

    vanilla = andy.items.create!(name: "Vanilla Ice Cream", description: "An instant classic", unit_price: 500)
    skull = april.items.create!(name: "Skull", description: "Genuine dragon skull", unit_price: 125459)
    suit = tom.items.create!(name: "Suede Suit", description: "Look as good as you feel", unit_price: 15000)
    waffle = leslie.items.create!(name: "Waffles", description: "Made with love and high quality batter", unit_price: 1000)

    inv_1 = Invoice.create!(status: "Shipped", customer_id: cust_1.id, merchant_id: andy.id)
    inv_2 = Invoice.create!(status: "Shipped", customer_id: cust_1.id, merchant_id: andy.id)
    inv_3 = Invoice.create!(status: "Shipped", customer_id: cust_2.id, merchant_id: april.id)
    inv_4 = Invoice.create!(status: "Shipped", customer_id: cust_2.id, merchant_id: tom.id)
    inv_5 = Invoice.create!(status: "Shipped", customer_id: cust_2.id, merchant_id: leslie.id)

    InvoiceItem.create!(quantity: 8, unit_price: 500, invoice_id: inv_1.id, item_id: vanilla.id) # 4
    InvoiceItem.create!(quantity: 5, unit_price: 500, invoice_id: inv_2.id, item_id: vanilla.id) # 5
    InvoiceItem.create!(quantity: 1, unit_price: 125459, invoice_id: inv_3.id, item_id: skull.id) # 1
    InvoiceItem.create!(quantity: 2, unit_price: 15000, invoice_id: inv_4.id, item_id: suit.id) # 2
    InvoiceItem.create!(quantity: 12, unit_price: 1000, invoice_id: inv_5.id, item_id: waffle.id) # 3

    Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: "", result: "failed", invoice_id: inv_1.id)
    Transaction.create!(credit_card_number: 4140149827486249, credit_card_expiration_date: "", result: "success", invoice_id: inv_2.id)
    Transaction.create!(credit_card_number: 4214497729954420, credit_card_expiration_date: "", result: "success", invoice_id: inv_3.id)
    Transaction.create!(credit_card_number: 4173081602435789, credit_card_expiration_date: "", result: "failed", invoice_id: inv_4.id)
    Transaction.create!(credit_card_number: 4219320645843480, credit_card_expiration_date: "", result: "success", invoice_id: inv_5.id)

    get '/api/v1/merchants/most_revenue?quantity=3'

    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq(3)
    expect(merchants["data"].first["id"]).to eq(april.id.to_s)
    expect(merchants["data"].last["id"]).to eq(andy.id.to_s)
    expect(merchants["data"].any? {|h| h["id"] == "#{tom.id}"}).to eq(false)
  end

  it 'can return total revenue for specific date' do
    andy = Merchant.create!(name: "Andy's Ice Cream Shop")

    cust_1 = Customer.create!(first_name: "George", last_name: "Wilbur")

    vanilla = andy.items.create!(name: "Vanilla Ice Cream", description: "An instant classic", unit_price: 500)

    inv_1 = Invoice.create!(status: "Shipped", customer_id: cust_1.id, merchant_id: andy.id, created_at: "2012-03-06 15:54:17 UTC")
    inv_2 = Invoice.create!(status: "Shipped", customer_id: cust_1.id, merchant_id: andy.id, created_at: "2012-03-06 11:26:02 UTC")
    inv_3 = Invoice.create!(status: "Shipped", customer_id: cust_1.id, merchant_id: andy.id, created_at: "2012-03-06 13:32:45 UTC")
    inv_4 = Invoice.create!(status: "Shipped", customer_id: cust_1.id, merchant_id: andy.id, created_at: "2014-05-14 15:54:17 UTC")

    InvoiceItem.create!(quantity: 8, unit_price: 500, invoice_id: inv_1.id, item_id: vanilla.id)
    InvoiceItem.create!(quantity: 5, unit_price: 500, invoice_id: inv_2.id, item_id: vanilla.id)
    InvoiceItem.create!(quantity: 1, unit_price: 500, invoice_id: inv_3.id, item_id: vanilla.id)
    InvoiceItem.create!(quantity: 3, unit_price: 500, invoice_id: inv_4.id, item_id: vanilla.id)

    Transaction.create!(credit_card_number: 4654405418249632, credit_card_expiration_date: "", result: "success", invoice_id: inv_1.id)
    Transaction.create!(credit_card_number: 4140149827486249, credit_card_expiration_date: "", result: "success", invoice_id: inv_2.id)
    Transaction.create!(credit_card_number: 4214497729954420, credit_card_expiration_date: "", result: "failed", invoice_id: inv_3.id)
    Transaction.create!(credit_card_number: 4173081602435789, credit_card_expiration_date: "", result: "success", invoice_id: inv_4.id)

    get '/api/v1/merchants/revenue?date=2012-03-06 06:16:09 UTC'

    total_revenue = JSON.parse(response.body)

    expect(response).to be_successful
    expect(total_revenue["data"]["attributes"]["total_revenue"].to_i).to eq(65)
  end

