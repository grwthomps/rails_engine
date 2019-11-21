class Api::V1::Merchants::SearchController < ApplicationController
  def find
    render json: MerchantSerializer.new(Merchant.find_by(find_params))
  end

  def find_all
    render json: MerchantSerializer.new(Merchant.where(find_params))
  end

  private

  def find_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
