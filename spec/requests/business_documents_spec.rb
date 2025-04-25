require 'rails_helper'

RSpec.describe "BusinessDocuments", type: :request do
  describe "GET /business_documents/by_user/:user_id" do
    let!(:admin_user) { create(:user) }
    let!(:admin_role) { create(:role, name: 'admin') }
    let!(:admin_user_role) { create(:user_role, user: admin_user, role: admin_role) }
    let!(:admin_token) { Bscf::Core::TokenService.new.encode({ user: { id: admin_user.id }, role: { name: admin_role.name } }) }
    let!(:admin_headers) do
      { Authorization: "Bearer #{admin_token}" }
    end

    let!(:target_user) { create(:user) }
    let!(:business) { create(:business, user: target_user) }
    let!(:documents) { create_list(:business_document, 3, business: business) }

    context "when admin requests with valid user_id" do
      it "returns the business and its documents" do
        get by_user_business_documents_path(target_user.id), headers: admin_headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["business"]["id"]).to eq(business.id)
        expect(json_response["business"]["user_id"]).to eq(target_user.id)
        expect(json_response["documents"].length).to eq(3)
      end
    end

    context "when user does not exist" do
      it "returns not found status" do
        get by_user_business_documents_path(0), headers: admin_headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("User not found")
      end
    end

    context "when user has no business" do
      let!(:user_without_business) { create(:user) }

      it "returns not found status" do
        get by_user_business_documents_path(user_without_business.id), headers: admin_headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("No business found for this user")
      end
    end

    context "when non-admin user tries to access" do
      let!(:regular_user) { create(:user) }
      let!(:regular_role) { create(:role, name: 'user') }
      let!(:regular_user_role) { create(:user_role, user: regular_user, role: regular_role) }
      let!(:regular_token) { Bscf::Core::TokenService.new.encode({ user: { id: regular_user.id }, role: { name: regular_role.name } }) }
      let!(:regular_headers) do
        { Authorization: "Bearer #{regular_token}" }
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        get by_user_business_documents_path(target_user.id)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
