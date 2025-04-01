class OrdersController < ApplicationController
  include Common
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

  def create_with_items
    ActiveRecord::Base.transaction do
      @order = Bscf::Core::Order.new(order_params)
      @order.ordered_by = current_user

      unless @order.save
        render json: { success: false, errors: @order.errors.full_messages }, status: :unprocessable_entity
        return
      end

      order_items_params.each do |item_params|
        item = @order.order_items.build(item_params)
        unless item.save
          raise ActiveRecord::Rollback
          render json: { success: false, errors: item.errors.full_messages }, status: :unprocessable_entity
          return
        end
      end

      render json: {
        success: true,
        order: @order,
        order_items: @order.order_items
      }, status: :created
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :ordered_to_id,
      :quotation_id,
      :order_type,
      :status,
      :total_amount
    )
  end

  def order_items_params
    params.require(:order_items).map do |item|
      item.permit(
        :product_id,
        :quotation_item_id,
        :quantity,
        :unit_price,
        :subtotal
      )
    end
  end

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
