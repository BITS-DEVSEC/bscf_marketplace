class DeliveryOrdersController < ApplicationController
  include Common
  before_action :is_authenticated
  before_action :set_delivery_order, only: [ :assign_driver, :start_delivery, :complete_delivery, :cancel, :assign_orders ]

  def index
    @delivery_orders = model_class.includes(:orders, :driver, :dropoff_address, :pickup_address, :delivery_order_items)
    @delivery_orders = filter_records(@delivery_orders) if params[:q].present?
    
    if @delivery_orders.empty?
      render json: { success: false, error: "No delivery orders found" }, status: :not_found
      return
    end

    render json: {
      success: true,
      data: serialize(@delivery_orders, each_serializer: DeliveryOrderSerializer)
    }, status: :ok
  end

  def show
    @delivery_order = model_class.includes(:orders, :driver, :dropoff_address, :pickup_address, :delivery_order_items)
                                .find(params[:id])
    
    render json: {
      success: true,
      data: serialize(@delivery_order, serializer: DeliveryOrderSerializer)
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "Delivery order not found" }, status: :not_found
  end

  def my_deliveries
    @delivery_orders = model_class.includes(:orders, :driver, :dropoff_address, :pickup_address)
                                 .where(driver_id: current_user.id)
    if @delivery_orders.empty?
      render json: { success: false, error: "No deliveries found" }, status: :not_found
      return
    end
    render json: { success: true, data: serialize(@delivery_orders, each_serializer: DeliveryOrderSerializer) }, status: :ok
  end

  def assign_orders
    order_ids = params[:payload][:order_ids]

    ActiveRecord::Base.transaction do
      orders = Bscf::Core::Order.where(id: order_ids)
      
      if orders.empty?
        render json: { success: false, error: "No valid orders found" }, status: :not_found
        return
      end

      orders.each do |order|
        order.update!(delivery_order: @delivery_order)
      end

      render json: {
        success: true,
        data: serialize(@delivery_order.reload, serializer: DeliveryOrderSerializer)
      }, status: :ok
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  def assigned_deliveries
    @delivery_orders = model_class.includes(:orders).where(driver_id: current_user.id, status: 1)
    if @delivery_orders.empty?
      render json: { success: false, error: "No assigned deliveries found" }, status: :not_found
      return
    end
    render json: { success: true, data: serialize(@delivery_orders, each_serializer: DeliveryOrderSerializer) }, status: :ok
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
    if @delivery_order.update(driver_id: params[:payload][:driver_id], status: :in_transit)
      render json: { success: true, data: serialize(@delivery_order, serializer: DeliveryOrderSerializer) }, status: :ok
    else
      render json: { success: false, error: @delivery_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def start_delivery
    ActiveRecord::Base.transaction do
      @delivery_order.update!(status: :picked_up, delivery_start_time: Time.current)
      render json: { success: true, data: serialize(@delivery_order, serializer: DeliveryOrderSerializer) }, status: :ok
    end  
  rescue ActiveRecord::RecordInvalid => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  def complete_delivery
    if @delivery_order.update(status: :delivered, delivery_end_time: Time.current)
      render json: { success: true, data: serialize(@delivery_order, serializer: DeliveryOrderSerializer) }, status: :ok
    else
      render json: { success: false, error: @delivery_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def cancel
    if @delivery_order.status == "delivered"
      render json: { success: false, error: "Cannot cancel a delivered order" }, status: :unprocessable_entity
      return
    end

    if @delivery_order.update(status: :pending, driver_id: nil)
      render json: { success: true, data: serialize(@delivery_order, serializer: DeliveryOrderSerializer) }, status: :ok
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
