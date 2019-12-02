class Api::V1::Invoices::SearchController < ApplicationController
  def find
    render json: InvoiceSerializer.new(Invoice.find_by(find_params))
  end

  def find_all
    render json: InvoiceSerializer.new(Invoice.where(find_params).order(:id))
  end

  private

  def find_params
    params.permit(:id, :status, :customer_id, :merchant_id, :created_at, :updated_at)
  end
end
