class DeliveryOrdersController < ApplicationController
  include Common
  before_action :is_authenticated
  before_action :set_order, only: [ :accept_delivery ]

  def my_delivery_orders
    @delivery_orders = Bscf::Core::DeliveryOrder.where(driver_id: current_user.id)
    if @delivery_orders.empty?
      render json: { success: false, error: "No delivery orders found" }, status: :not_found
      return
    end
    render json: { success: true, data: @delivery_orders }, status: :ok
  end

  def accept_delivery
    if @delivery_order.update(driver_id: current_user.id, status: :assigned)
      render json: { success: true, data: @delivery_order }, status: :ok
    else
      render json: { success: false, error: @delivery_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @delivery_order = Bscf::Core::DeliveryOrder.find(params[:id])
  end

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :order_id,
      :driver_id,
      :status,
      :pickup_location,
      :delivery_location,
      :delivery_notes
    ]
  end
end
