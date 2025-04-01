class MarketplaceListingsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :user_id,
      :listing_type,
      :status,
      :allow_partial_match,
      :expires_at,
      :address_id
    ]
  end
end
