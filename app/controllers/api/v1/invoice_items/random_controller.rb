class Api::V1::InvoiceItems::RandomController < ApplicationController
  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.find(InvoiceItem.pluck(:id).sample))
  end
end
