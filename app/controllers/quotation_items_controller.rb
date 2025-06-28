class QuotationItemsController < ApplicationController
  include Common

  def includes
    [ :quotation, :rfq_item, product: [ :thumbnail_attachment, :images_attachments ] ]
  end

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
