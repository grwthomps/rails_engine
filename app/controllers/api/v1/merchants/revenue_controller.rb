class Api::V1::Merchants::RevenueController < ApplicationController
  def highest_total_revenue
    render json: MerchantSerializer.new(Merchant.highest_total_revenue(params[:quantity]))
  end

  def total_revenue
    render json: {data: {attributes: {total_revenue: Invoice.total_revenue_on_date(params["date"]).to_s}}}
  end
end
