class MarketplaceListingsController < ApplicationController
  include Common
  before_action :is_authenticated

  def my_marketplace_listings
    @marketplace_listings = Bscf::Core::MarketplaceListing.where(user: current_user)
    if @marketplace_listings.empty?
      render json: { success: false, error: "No marketplace listings found" }, status: :not_found
      return
    end
    render json: { success: true, data: @marketplace_listings, status: :ok }
  end

  def includes
    [:user, :address]
  end

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
