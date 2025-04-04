class QuotationsController < ApplicationController
  include Common
  include CreatableWithItems
  before_action :is_authenticated

  private

  def permitted_params
    [
      :request_for_quotation_id,
      :business_id,
      :price,
      :delivery_date,
      :valid_until,
      :status,
      :notes
    ]
  end

  def permitted_item_params
    [
      :rfq_item_id,
      :product_id,
      :quantity,
      :unit_price,
      :unit,
      :subtotal
    ]
  end
end
