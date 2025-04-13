require "rails_helper"

RSpec.describe "BusinessDocuments", type: :request do
  include ActionDispatch::TestProcess

  let(:valid_attributes) do
    {
      document_number: "DOC123",
      document_name: "Business License",
      document_description: "Official business license document",
      business_id: create(:business).id,
      file: fixture_file_upload('spec/fixtures/files/sample.pdf', 'application/pdf')
    }
  end

  let(:invalid_attributes) do
    {
      document_number: nil,
      document_name: nil,
      document_description: nil,
      business_id: nil
    }
  end

  let(:new_attributes) do
    {
      document_name: "Updated License",
      document_description: "Updated description",
    }
  end

  describe "GET /my_business_documents" do
    let!(:user) { create(:user) }
    let!(:role) { create(:role) }
    let!(:user_role) { create(:user_role, user: user, role: role) }
    let!(:token) { Bscf::Core::TokenService.new.encode({ user: { id: user.id }, role: { name: role.name } }) }
    let!(:headers) do
      { Authorization: "Bearer #{token}" }
    end

    context "when user has a business with documents" do
      let!(:business) { create(:business, user: user) }
      let!(:documents) { create_list(:business_document, 3, business: business) }

      it "returns the business documents" do
        get "/business_documents/my_business_documents", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["data"].length).to eq(3)
        expect(json_response["data"].first["business_id"]).to eq(business.id)
      end
    end

    context "when user has no business" do
      it "returns not found" do
        get "/business_documents/my_business_documents", headers: headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("No business found for current user")
      end
    end
  end

  include_examples "request_shared_spec", "business_documents", 10, [:create]
end
