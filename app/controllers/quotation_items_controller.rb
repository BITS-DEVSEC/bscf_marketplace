class QuotationItemsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :quotation_id,
      :rfq_item_id,
      :product_id,
      :quantity,
      :unit_price,
      :unit,
      :subtotal
    ]
  end
end