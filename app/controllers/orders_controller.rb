class OrdersController < ApplicationController
  include Common
  before_action :is_authenticated

  def my_orders
    @orders = Bscf::Core::Order.where(ordered_by: current_user)
    if @orders.empty?
      render json: { success: false, error: "No orders found" }, status: :not_found
      return
    end
    render json: { success: true, data: @orders, status: :ok }
  end

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :ordered_by_id,
      :ordered_to_id,
      :quotation_id,
      :order_type,
      :status,
      :total_amount
    ]
  end
end
