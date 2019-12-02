class Api::V1::InvoiceItems::SearchController < ApplicationController
  def find
    render json: InvoiceItemSerializer.new(InvoiceItem.find_by(find_params))
  end

  def find_all
    render json: InvoiceItemSerializer.new(InvoiceItem.where(find_params))
  end

  private

  def find_params
    params.permit(:id, :quantity, :unit_price, :invoice_id, :item_id, :created_at, :updated_at)
  end
end
