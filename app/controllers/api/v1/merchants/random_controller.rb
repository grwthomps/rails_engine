class Api::V1::Merchants::RandomController < ApplicationController
  def show
    render json: MerchantSerializer.new(Merchant.find(Merchant.pluck(:id).sample))
  end
end
