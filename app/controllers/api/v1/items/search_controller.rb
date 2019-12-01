class Api::V1::Items::SearchController < ApplicationController
  def find
    render json: ItemSerializer.new(Item.find_by(find_params))
  end

  def find_all
    render json: ItemSerializer.new(Item.where(find_params))
  end

  private

  def find_params
    params.permit(:id, :name, :description, :unit_price, :created_at, :updated_at, :merchant_id)
  end
end
