class Api::V1::Invoices::RandomController < ApplicationController
  def show
    render json: InvoiceSerializer.new(Invoice.find(Invoice.pluck(:id).sample))
  end
end
