class Api::V1::Customers::RandomController < ApplicationController
  def show
    render json: CustomerSerializer.new(Customer.find(Customer.pluck(:id).sample))
  end
end
