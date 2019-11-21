require 'rails_helper'

describe 'Merchants API - Relationships Endpoint' do
  it 'can return items associated with a merchant' do
    forrest = Merchant.create!(name: "Forrest Gump's Gumbo")
    jenny = Merchant.create!(name: "Jenny's Fabulous Flowers")
    gumbo = forrest.items.create!(name: 'Hearty Shrimp Gumbo', description: "It'll make you feel all warm inside", unit_price: 1499)
    poboy = forrest.items.create!(name: 'Shrimp Poboy', description: "Made fresh with only the best shrimp and seasoning", unit_price: 800)
    tulip = jenny.items.create!(name: 'Tulip', description: "Very beautiful", unit_price: 200)

    get "/api/v1/merchants/#{forrest.id}/items"

    merchant_items = JSON.parse(response.body)

    expect(merchant_items["data"].count).to eq(2)
    expect(merchant_items["data"].first["id"]).to eq(gumbo.id.to_s)
    expect(merchant_items["data"].any? {|h| h["id"] == "#{tulip.id}"}).to eq(false)
  end

  it 'can return invoices associated with a merchant' do
    forrest = Merchant.create!(name: "Forrest Gump's Gumbo")
    jenny = Merchant.create!(name: "Jenny's Fabulous Flowers")
    andy = Customer.create!(first_name: 'Andy', last_name: 'Dwyer')
    april = Customer.create!(first_name: 'April', last_name: 'Ludgate')
    inv_1 = Invoice.create!(status: 'shipped', customer_id: andy.id, merchant_id: forrest.id)
    inv_2 = Invoice.create!(status: 'shipped', customer_id: april.id, merchant_id: forrest.id)
    inv_3 = Invoice.create!(status: 'shipped', customer_id: andy.id, merchant_id: jenny.id)

    get "/api/v1/merchants/#{forrest.id}/invoices"

    merchant_invoices = JSON.parse(response.body)

    expect(merchant_invoices["data"].count).to eq(2)
    expect(merchant_invoices["data"].last["id"]).to eq(inv_2.id.to_s)
    expect(merchant_invoices["data"].any? {|h| h["id"] == "#{inv_3.id}"}).to eq(false)
  end
end
