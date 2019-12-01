class Api::V1::Transactions::SearchController < ApplicationController
  def find
    render json: TransactionSerializer.new(Transaction.find_by(find_params))
  end

  def find_all
    render json: TransactionSerializer.new(Transaction.where(find_params))
  end

  private

  def find_params
    params.permit(:id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at, :invoice_id)
  end
end
