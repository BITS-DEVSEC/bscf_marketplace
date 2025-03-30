class OrderItemsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :order_id,
      :product_id,
      :quotation_item_id,
      :quantity,
      :unit_price,
      :subtotal
    ]
  end
end
