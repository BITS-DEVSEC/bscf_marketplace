require 'rails_helper'

RSpec.describe 'RequestForQuotations', type: :request do
  let(:valid_attributes) do
    {
      user_id: create(:user).id,
      status: "draft",
      notes: "Sample RFQ notes"
    }
  end

  let(:invalid_attributes) do
    {
      user_id: nil,
      status: nil,
      notes: nil
    }
  end

  let(:new_attributes) do
    {
      status: "submitted",
      notes: "Updated notes"
    }
  end

  describe "GET /my_rfqs" do
    let!(:user) { create(:user) }
    let!(:role) { create(:role) }
    let!(:user_role) { create(:user_role, user: user, role: role) }
    let!(:token) { Bscf::Core::TokenService.new.encode({ user: { id: user.id }, role: { name: role.name } }) }
    let!(:headers) do
      { Authorization: "Bearer #{token}" }
    end

    context "when user has RFQs" do
      let!(:user_rfqs) { create_list(:request_for_quotation, 3, user: user) }
      let!(:rfq_items) { user_rfqs.map { |rfq| create_list(:rfq_item, 2, request_for_quotation: rfq) }.flatten }
      let!(:other_user_rfqs) { create_list(:request_for_quotation, 2) }

      it "returns only the current user RFQs and their items" do
        get "/request_for_quotations/my_rfqs", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["rfqs"].length).to eq(3)
        expect(json_response["rfqs"].pluck("user_id")).to all(eq(user.id))
        expect(json_response["rfq_items"].length).to eq(6) # 3 RFQs × 2 items each

        returned_rfq_ids = json_response["rfq_items"].pluck("request_for_quotation_id").uniq.sort
        expect(returned_rfq_ids).to match_array(user_rfqs.pluck(:id))
      end
    end

    context "when user has no RFQs" do
      let!(:other_user_rfqs) { create_list(:request_for_quotation, 2) }

      it "returns not found status with error message" do
        get "/request_for_quotations/my_rfqs", headers: headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("No RFQs found")
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        get "/request_for_quotations/my_rfqs"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  include_examples 'request_shared_spec', 'request_for_quotations', 7
end
