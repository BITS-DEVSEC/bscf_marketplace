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

  describe "GET /my_marketplace_listings" do
    let!(:user) { create(:user) }
    let!(:role) { create(:role) }
    let!(:user_role) { create(:user_role, user: user, role: role) }
    let!(:token) { Bscf::Core::TokenService.new.encode({ user: { id: user.id }, role: { name: role.name } }) }
    let!(:headers) do
      { Authorization: "Bearer #{token}" }
    end

    context "when user has marketplace listings" do
      let!(:user_listings) { create_list(:marketplace_listing, 3, user: user) }
      let!(:other_user_listings) { create_list(:marketplace_listing, 2) }

      it "returns only the current user marketplace listings" do
        get "/marketplace_listings/my_marketplace_listings", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["data"].length).to eq(3)
        expect(json_response["data"].pluck("user_id")).to all(eq(user.id))
      end
    end

    context "when user has no marketplace listings" do
      let!(:other_user_listings) { create_list(:marketplace_listing, 2) }

      it "returns not found status with error message" do
        get "/marketplace_listings/my_marketplace_listings", headers: headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("No marketplace listings found")
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        get "/marketplace_listings/my_marketplace_listings"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  include_examples "request_shared_spec", "marketplace_listings", 7
end
