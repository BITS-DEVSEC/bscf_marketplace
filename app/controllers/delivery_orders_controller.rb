class DeliveryOrdersController < ApplicationController
  include Common
  before_action :is_authenticated
  before_action :set_delivery_order, only: [:assign_driver, :start_delivery, :complete_delivery]

  def my_deliveries
    @delivery_orders = Bscf::Core::DeliveryOrder.where(driver_id: current_user.id)
    render json: { success: true, data: @delivery_orders }, status: :ok
  end

  def assigned_deliveries
    @delivery_orders = Bscf::Core::DeliveryOrder.where(driver_id: current_user.id, status: :assigned)
    render json: { success: true, data: @delivery_orders }, status: :ok
  end

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :order_id,
      :dropoff_address_id,
      :pickup_address_id,
      :driver_phone,
      :buyer_phone,
      :seller_phone,
      :delivery_notes,
      :estimated_delivery_time,
      :delivery_start_time,
      :delivery_end_time,
      :actual_delivery_time,
      :status,
      :driver_id
    ]
  end

  def set_delivery_order
    @delivery_order = Bscf::Core::DeliveryOrder.find(params[:id])
  end
end
