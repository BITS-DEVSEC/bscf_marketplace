class DeliveryOrdersController < ApplicationController
  include Common
  before_action :is_authenticated
  before_action :set_delivery_order, only: [ :assign_driver, :start_delivery, :complete_delivery ]

  def my_deliveries
    @delivery_orders = Bscf::Core::DeliveryOrder.where(driver_id: current_user.id)
    if @delivery_orders.empty?
      render json: { success: false, error: "No deliveries found" }, status: :not_found
      return
    end
    render json: { success: true, data: @delivery_orders }, status: :ok
  end

  def assigned_deliveries
    @delivery_orders = model_class.where(driver_id: current_user.id, status: 1)
    if @delivery_orders.empty?
      render json: { success: false, error: "No assigned deliveries found" }, status: :not_found
      return
    end
    render json: { success: true, data: @delivery_orders }, status: :ok
  end

  def daily_aggregates
    @aggregates = model_class
      .where(driver_id: current_user.id)
      .where("delivery_end_time >= ?", Date.today.beginning_of_day)
      .where("delivery_end_time <= ?", Date.today.end_of_day)
      .where.not(delivery_end_time: nil)
      .group("DATE(delivery_end_time)")
      .select(
        "DATE(delivery_end_time) as date",
        "COUNT(*) as total_deliveries",
        "SUM(delivery_price) as total_amount"
      )

    if @aggregates.empty?
      render json: { success: false, error: "No completed deliveries found for today" }, status: :not_found
      return
    end

    render json: { success: true, data: @aggregates }, status: :ok
  end

  def monthly_aggregates
    @aggregates = model_class
      .where(driver_id: current_user.id)
      .where("delivery_end_time >= ?", Date.today.beginning_of_month)
      .where("delivery_end_time <= ?", Date.today.end_of_month)
      .group("DATE(delivery_end_time)")
      .select(
        "DATE(delivery_end_time) as date",
        "COUNT(*) as total_deliveries",
        "SUM(delivery_price) as total_amount"
      )

    render json: { success: true, data: @aggregates }, status: :ok
  end

  def assign_driver
    if @delivery_order.update(driver_id: params[:payload][:driver_id])
      render json: { success: true, data: @delivery_order }, status: :ok
    else
      render json: { success: false, error: @delivery_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def start_delivery
    if @delivery_order.update(status: :in_progress, delivery_start_time: Time.current)
      render json: { success: true, data: @delivery_order }, status: :ok
    else
      render json: { success: false, error: @delivery_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def complete_delivery
    if @delivery_order.update(status: :delivered, delivery_end_time: Time.current, actual_delivery_time: Time.current)
      render json: { success: true, data: @delivery_order }, status: :ok
    else
      render json: { success: false, error: @delivery_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def model_class
    Bscf::Core::DeliveryOrder
  end

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
      :delivery_price,
      :status,
      :driver_id
    ]
  end

  def set_delivery_order
    @delivery_order = model_class.find(params[:id])
  end
end
