class OrdersController < ApplicationController
  include Common
  include CreatableWithItems
  before_action :is_authenticated

  def index
    @orders = model_class.includes(:ordered_by, :ordered_to, :quotation, :delivery_order)
    @orders = filter_records(@orders) if params[:q].present?
    
    if @orders.empty?
      render json: { success: false, error: "No orders found" }, status: :not_found
      return
    end

    render json: {
      success: true,
      data: serialize(@orders, each_serializer: OrderSerializer)
    }, status: :ok
  end

  def show
    @order = model_class.includes(:ordered_by, :ordered_to, :quotation, :delivery_order)
                        .find(params[:id])
    
    render json: {
      success: true,
      data: serialize(@order, serializer: OrderSerializer)
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "Order not found" }, status: :not_found
  end

  def my_orders
    @orders = model_class.includes(:order_items, :delivery_order)
                        .where(ordered_by: current_user)
    if @orders.empty?
      render json: { success: false, error: "No orders found" }, status: :not_found
      return
    end
    render json: { success: true, data: serialize(@orders, each_serializer: OrderSerializer) }, status: :ok
  end

  private

  def model_class
    Bscf::Core::Order
  end

  def model_params
    params.require(:payload).permit(permitted_params).merge(ordered_by_id: current_user.id)
  end

  def permitted_params
    [
      :ordered_to_id,
      :quotation_id,
      :delivery_order_id,
      :order_type,
      :status,
      :total_amount,
      :payment_status,
      :payment_method,
      :payment_reference,
      :payment_date,
      :notes
    ]
  end

  def permitted_item_params
    [
      :product_id,
      :quotation_item_id,
      :quantity,
      :unit_price,
      :subtotal
    ]
  end
end
