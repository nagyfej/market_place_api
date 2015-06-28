class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def index
    render json: current_user.orders, status: 200
  end

  def show
    order = current_user.orders.find(params[:id])
    render json: order, status: 200
  end

end
