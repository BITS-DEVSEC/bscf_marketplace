class RequestForQuotationsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    # Add your permitted params here
    [:user_id, :status, :notes]
  end
end
