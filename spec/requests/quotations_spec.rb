require 'rails_helper'

RSpec.describe 'Quotations', type: :request do
  let(:valid_attributes) do
    {
      request_for_quotation_id: create(:request_for_quotation).id,
      business_id: create(:business).id,
      price: Faker::Commerce.price,
      delivery_date: Date.tomorrow,
      valid_until: 1.week.from_now,
      status: 0,
      notes: "Sample quotation notes"
    }
  end

  let(:invalid_attributes) do
    {
      request_for_quotation_id: nil,
      business_id: nil,
      price: nil,
      delivery_date: nil,
      valid_until: nil
    }
  end

  let(:new_attributes) do
    {
      price: Faker::Commerce.price,
      delivery_date: 2.days.from_now,
      notes: "Updated quotation notes"
    }
  end

  describe "GET /my_quotations" do
    let!(:user) { create(:user) }
    let!(:business) { create(:business, user: user) }
    let!(:role) { create(:role) }
    let!(:user_role) { create(:user_role, user: user, role: role) }
    let!(:token) { Bscf::Core::TokenService.new.encode({ user: { id: user.id }, role: { name: role.name } }) }
    let!(:headers) do
      { Authorization: "Bearer #{token}" }
    end

    context "when business has quotations" do
      let!(:business_quotations) { create_list(:quotation, 3, business: business) }
      let!(:quotation_items) { business_quotations.map { |quot| create_list(:quotation_item, 2, quotation: quot) }.flatten }
      let!(:other_business_quotations) { create_list(:quotation, 2) }

      it "returns only the current business quotations and their items" do
        get "/quotations/my_quotations", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["quotations"].length).to eq(3)
        expect(json_response["quotations"].pluck("business_id")).to all(eq(business.id))
        expect(json_response["quotation_items"].length).to eq(6) # 3 quotations × 2 items each

        returned_quotation_ids = json_response["quotation_items"].pluck("quotation_id").uniq.sort
        expect(returned_quotation_ids).to match_array(business_quotations.pluck(:id))
      end
    end

    context "when business has no quotations" do
      let!(:other_business_quotations) { create_list(:quotation, 2) }

      it "returns not found status with error message" do
        get "/quotations/my_quotations", headers: headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("No quotations found")
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        get "/quotations/my_quotations"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  include_examples 'request_shared_spec', 'quotations', 11
end
