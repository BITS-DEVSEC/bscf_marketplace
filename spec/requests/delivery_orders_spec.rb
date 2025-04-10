require 'rails_helper'

RSpec.describe 'DeliveryOrders', type: :request do
  let(:valid_attributes) do
    {
      order_id: create(:order).id,
      dropoff_address_id: create(:address).id,
      pickup_address_id: create(:address).id,
      driver_phone: Faker::PhoneNumber.cell_phone,
      buyer_phone: Faker::PhoneNumber.cell_phone,
      seller_phone: Faker::PhoneNumber.cell_phone,
      delivery_notes: "Handle with care",
      estimated_delivery_time: 1.day.from_now,
      status: 0
    }
  end

  let(:invalid_attributes) do
    {
      order_id: nil,
      dropoff_address_id: nil,
      pickup_address_id: nil,
      driver_phone: nil,
      buyer_phone: nil,
      seller_phone: nil,
      estimated_delivery_time: nil
    }
  end

  let(:new_attributes) do
    {
      delivery_notes: "Updated delivery instructions",
      estimated_delivery_time: 2.days.from_now,
      status: 1
    }
  end

  let!(:user) { create(:user) }
  let!(:role) { create(:role) }
  let!(:user_role) { create(:user_role, user: user, role: role) }
  let!(:token) { Bscf::Core::TokenService.new.encode({ user: { id: user.id }, role: { name: role.name } }) }
  let!(:headers) { { Authorization: "Bearer #{token}" } }

  describe "GET /my_deliveries" do
    context "when user has deliveries" do
      let!(:delivery_orders) { create_list(:delivery_order, 3, driver: user) }

      it "returns a list of user's delivery orders" do
        get my_deliveries_delivery_orders_path, headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be true
        expect(json_response["data"].length).to eq(3)
      end
    end

    context "when user has no deliveries" do
      it "returns not found status" do
        get my_deliveries_delivery_orders_path, headers: headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("No deliveries found")
      end
    end
  end

  describe "GET /assigned_deliveries" do
    context "when user has assigned deliveries" do
      let!(:assigned_deliveries) { create_list(:delivery_order, 2, driver: user, status: 1) }

      it "returns a list of assigned delivery orders" do
        get assigned_deliveries_delivery_orders_path, headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be true
        expect(json_response["data"].length).to eq(2)
      end
    end

    context "when user has no assigned deliveries" do
      it "returns not found status" do
        get assigned_deliveries_delivery_orders_path, headers: headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("No assigned deliveries found")
      end
    end
  end

  describe "GET /daily_aggregates" do
    context "when user has no completed deliveries" do
      it "returns not found status" do
        get daily_aggregates_delivery_orders_path, headers: headers

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be false
        expect(json_response["error"]).to eq("No completed deliveries found for today")
      end
    end
  end

  describe "GET /monthly_aggregates" do
    context "when user has deliveries" do
      let!(:delivery_orders) do
        create_list(:delivery_order, 3,
          driver: user,
          status: 3,
          delivery_end_time: Time.current,
          delivery_price: 100.00
        )
      end

      it "returns monthly delivery aggregates" do
        get monthly_aggregates_delivery_orders_path, headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be true
        expect(json_response["data"].first["total_deliveries"]).to eq(3)
        expect(json_response["data"].first["total_amount"].to_f).to eq(300.00)
      end
    end
  end

  include_examples 'request_shared_spec', 'delivery_orders', 18
end
