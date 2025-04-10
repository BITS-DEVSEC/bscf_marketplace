class DeliveryOrderItemsController < ApplicationController
  include Common
  before_action :is_authenticated

  private

  def model_class
    Bscf::Core::DeliveryOrderItem
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
