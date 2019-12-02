class Api::V1::Customers::SearchController < ApplicationController
  def find
    render json: CustomerSerializer.new(Customer.find_by(find_params))
  end

  def find_all
    render json: CustomerSerializer.new(Customer.where(find_params).order(:id))
  end

  private

  def find_params
    params.permit(:id, :first_name, :last_name, :created_at, :updated_at)
  end
end
