class Api::V1::Items::RandomController < ApplicationController
  def show
    render json: ItemSerializer.new(Item.find(Item.pluck(:id).sample))
  end
end
