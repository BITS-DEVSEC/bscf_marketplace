class RfqItemsController < ApplicationController
  include Common

  def includes
    [ :product, :request_for_quotation, product: [ :thumbnail_attachment, :images_attachments ] ]
  end

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [ :request_for_quotation_id, :product_id, :quantity, :notes ]
  end
end
