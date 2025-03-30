class QuotationsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

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
end
