require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  let(:valid_attributes) do
    {
      ordered_by_id: create(:user).id,
      ordered_to_id: create(:user).id,
      quotation_id: create(:quotation).id,
      order_type: 0,
      status: 0,
      total_amount: 1500.50
    }
  end

  let(:invalid_attributes) do
    {
      ordered_by_id: nil,
      ordered_to_id: nil,
      order_type: nil,
      status: nil
    }
  end

  let(:new_attributes) do
    {
      status: "submitted",
      total_amount: 2000.00
    }
  end

  describe "GET /orders" do
    let!(:user) { create(:user) }
    let!(:role) { create(:role) }
    let!(:user_role) { create(:user_role, user: user, role: role) }
    let!(:token) { Bscf::Core::TokenService.new.encode({ user: { id: user.id }, role: { name: role.name } }) }
    let!(:headers) do
      { Authorization: "Bearer #{token}" }
    end

    context "when user has orders" do
      let!(:user_orders) { create_list(:order, 3, ordered_by: user) }
      let!(:other_user_orders) { create_list(:order, 2) }

      it "returns only the current user orders" do
        get "/orders/my_orders", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["data"].length).to eq(3)
        expect(json_response["data"].pluck("ordered_by_id")).to all(eq(user.id))
      end
    end

    context "when user has no orders" do
      let!(:other_user_orders) { create_list(:order, 2) }

      it "returns not found status with error message" do
        get "/orders/my_orders", headers: headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("No orders found")
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        # Remove the headers for unauthenticated request
        get "/orders/my_orders"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end



  include_examples 'request_shared_spec', 'orders', 9
end
