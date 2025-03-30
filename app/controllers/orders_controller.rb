class OrdersController < ApplicationController
  include Common

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
