class OrdersController < ApplicationController
  include Common
  include CreatableWithItems
  before_action :is_authenticated

  def my_orders
    @orders = Bscf::Core::Order.where(ordered_by: current_user)
    if @orders.empty?
      render json: { success: false, error: "No orders found" }, status: :not_found
      return
    end
    @order_items = Bscf::Core::OrderItem.where(order_id: @orders.pluck(:id))
    render json: { success: true, orders: @orders, order_items: @order_items, status: :ok }
  end

  private

  def model_params
    params.require(:payload).permit(permitted_params).merge(ordered_by_id: current_user.id)
  end

  def permitted_params
    [
      :ordered_to_id,
      :quotation_id,
      :order_type,
      :status,
      :total_amount
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
