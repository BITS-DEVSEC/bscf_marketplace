require "rails_helper"

RSpec.describe "Businesses", type: :request do
  let(:valid_attributes) do
    {
      business_name: "Test Business",
      business_type: 0,
      tin_number: "1234567890",
      user_id: create(:user).id,
      verification_status: 0
    }
  end

  let(:invalid_attributes) do
    {
      business_name: nil,
      business_type: nil,
      tin_number: nil,
      user_id: nil,
      verification_status: nil
    }
  end

  let(:new_attributes) do
    {
      business_name: "Updated Business Name",
      verification_status: 1
    }
  end

  describe "GET /my_business" do
    let!(:user) { create(:user) }
    let!(:role) { create(:role) }
    let!(:user_role) { create(:user_role, user: user, role: role) }
    let!(:token) { Bscf::Core::TokenService.new.encode({ user: { id: user.id }, role: { name: role.name } }) }
    let!(:headers) do
      { Authorization: "Bearer #{token}" }
    end

    context "when user has a business" do
      let!(:business) { create(:business, user: user) }

      it "returns the user's business" do
        get "/businesses/my_business", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["data"]["id"]).to eq(business.id)
        expect(json_response["data"]["user_id"]).to eq(user.id)
      end
    end
  end

  describe "GET /has_business" do
    let!(:user) { create(:user) }
    let!(:role) { create(:role) }
    let!(:user_role) { create(:user_role, user: user, role: role) }
    let!(:token) { Bscf::Core::TokenService.new.encode({ user: { id: user.id }, role: { name: role.name } }) }
    let!(:headers) do
      { Authorization: "Bearer #{token}" }
    end

    context "when user has a business" do
      let!(:business) { create(:business, user: user) }

      it "returns true" do
        get "/businesses/has_business", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["has_business"]).to be true
        expect(json_response["business"]["id"]).to eq(business.id)
      end
    end

    context "when user does not have a business" do
      it "returns false" do
        get "/businesses/has_business", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["has_business"]).to be false
      end
    end
  end

  include_examples "request_shared_spec", "businesses", 9
end
