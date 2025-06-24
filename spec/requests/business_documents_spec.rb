require 'rails_helper'

RSpec.describe "BusinessDocuments", type: :request do
  describe "GET /business_documents/by_user/:user_id" do
    let!(:admin_user) { create(:user) }
    let!(:admin_role) { create(:role, name: 'admin') }
    let!(:admin_user_role) { create(:user_role, user: admin_user, role: admin_role) }
    let!(:admin_token) do
      Bscf::Core::TokenService.new.encode({ user: { id: admin_user.id }, role: { name: admin_role.name } })
    end
    let!(:admin_headers) { { Authorization: "Bearer #{admin_token}" } }

    let!(:target_user) { create(:user) }
    let!(:documents) { create_list(:business_document, 3, user: target_user) }

    context "when admin requests with valid user_id" do
      it "returns the user's documents" do
        get by_user_business_documents_path(target_user.id), headers: admin_headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["success"]).to be true
        expect(json["user"]["id"]).to eq(target_user.id)
        expect(json["documents"].length).to eq(3)
      end
    end

    context "when user does not exist" do
      it "returns not found status" do
        get by_user_business_documents_path(0), headers: admin_headers

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)

        expect(json["success"]).to be false
        expect(json["error"]).to eq("User not found")
      end
    end

    context "when user has no documents" do
      let!(:user_without_documents) { create(:user) }

      it "returns empty documents array" do
        get by_user_business_documents_path(user_without_documents.id), headers: admin_headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["success"]).to be true
        expect(json["user"]["id"]).to eq(user_without_documents.id)
        expect(json["documents"]).to eq([])
      end
    end

    context "when non-admin user tries to access" do
      let!(:regular_user) { create(:user) }
      let!(:regular_role) { create(:role, name: 'user') }
      let!(:regular_user_role) { create(:user_role, user: regular_user, role: regular_role) }
      let!(:regular_token) do
        Bscf::Core::TokenService.new.encode({ user: { id: regular_user.id }, role: { name: regular_role.name } })
      end
      let!(:regular_headers) { { Authorization: "Bearer #{regular_token}" } }

      it "returns forbidden status" do
        get by_user_business_documents_path(target_user.id), headers: regular_headers

        expect(response).to have_http_status(:forbidden)
        json = JSON.parse(response.body)

        expect(json["success"]).to be false
        expect(json["error"]).to eq("Unauthorized access")
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
