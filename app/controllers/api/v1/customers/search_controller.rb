class Api::V1::Customers::SearchController < ApplicationController
  def find
    customer = render json: CustomerSerializer.new(Customer.find_by(find_params))
  end

  private

  def find_params
    params.permit(:id, :first_name, :last_name)
  end
end
