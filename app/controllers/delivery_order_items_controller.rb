class DeliveryOrderItemsController < ApplicationController
  include Common
  before_action :is_authenticated
  before_action :set_delivery_order, only: [:create]

  def create
    @delivery_order_item = Bscf::Core::DeliveryOrderItem.new(model_params)
    
    if @delivery_order_item.save
      render json: { success: true, data: @delivery_order_item }, status: :created
    else
      render json: { success: false, error: @delivery_order_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_delivery_order
    @delivery_order = Bscf::Core::DeliveryOrder.find(params[:delivery_order_id])
  end

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :delivery_order_id,
      :order_item_id,
      :product_id,
      :quantity,
      :status,
      :notes
    ]
  end
end