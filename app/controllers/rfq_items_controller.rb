class RfqItemsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [ :request_for_quotation_id, :product_id, :quantity, :notes ]
  end
end
