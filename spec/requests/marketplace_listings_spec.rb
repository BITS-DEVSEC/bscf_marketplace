require "rails_helper"

RSpec.describe "MarketplaceListings", type: :request do
  let(:valid_attributes) do
    {
      user_id: create(:user).id,
      listing_type: "buy",
      status: "open",
      allow_partial_match: true,
      expires_at: DateTime.now + 1.day,
      address_id: create(:address).id
    }
  end

  let(:invalid_attributes) do
    {
      user_id: nil,
      listing_type: "buy",
      status: "open",
      allow_partial_match: true,
      expires_at: DateTime.now + 1.day,
      address_id: nil
    }
  end

  let(:new_attributes) do
    {
      user_id: create(:user).id,
      listing_type: "sell",
      status: "open",
      allow_partial_match: true,
      expires_at: DateTime.now + 1.day,
      address_id: create(:address).id
    }
  end

  include_examples "request_shared_spec", "marketplace_listings", 7
end
