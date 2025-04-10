require 'rails_helper'

RSpec.describe 'DeliveryOrders', type: :request do
  let(:valid_attributes) do
    {
      order_id: create(:order).id,
      dropoff_address_id: create(:address).id,
      pickup_address_id: create(:address).id,
      driver_phone: Faker::PhoneNumber.phone_number,
      buyer_phone: Faker::PhoneNumber.phone_number,
      seller_phone: Faker::PhoneNumber.phone_number,
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
      estimated_delivery_time: 2.days.from_now
    }
  end

  describe "GET /my_deliveries" do
    let(:user) { create(:user) }
    let!(:delivery_orders) { create_list(:delivery_order, 3, driver: user) }
    
    before do
      sign_in_user(user)
    end

    it "returns a list of user's delivery orders" do
      get my_deliveries_delivery_orders_path, headers: auth_headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["success"]).to be true
      expect(json_response["data"].length).to eq(3)
    end
  end

  describe "GET /assigned_deliveries" do
    let(:user) { create(:user) }
    let!(:assigned_deliveries) { create_list(:delivery_order, 2, driver: user, status: :assigned) }
    
    before do
      sign_in_user(user)
    end

    it "returns a list of assigned delivery orders" do
      get assigned_deliveries_delivery_orders_path, headers: auth_headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["success"]).to be true
      expect(json_response["data"].length).to eq(2)
    end
  end

  describe "PUT /assign_driver" do
    let(:user) { create(:user) }
    let(:delivery_order) { create(:delivery_order) }
    
    before do
      sign_in_user(user)
    end

    it "assigns the delivery order to a driver" do
      put assign_driver_delivery_order_path(delivery_order), 
          params: { payload: { driver_id: user.id } },
          headers: auth_headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["success"]).to be true
      expect(json_response["data"]["driver_id"]).to eq(user.id)
      expect(json_response["data"]["status"]).to eq("assigned")
    end
  end

  describe "PUT /start_delivery" do
    let(:user) { create(:user) }
    let(:delivery_order) { create(:delivery_order, driver: user, status: :assigned) }
    
    before do
      sign_in_user(user)
    end

    it "starts the delivery" do
      put start_delivery_delivery_order_path(delivery_order), headers: auth_headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["success"]).to be true
      expect(json_response["data"]["status"]).to eq("in_progress")
      expect(json_response["data"]["delivery_start_time"]).to be_present
    end
  end

  describe "PUT /complete_delivery" do
    let(:user) { create(:user) }
    let(:delivery_order) { create(:delivery_order, driver: user, status: :in_progress) }
    
    before do
      sign_in_user(user)
    end

    it "completes the delivery" do
      put complete_delivery_delivery_order_path(delivery_order), headers: auth_headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["success"]).to be true
      expect(json_response["data"]["status"]).to eq("delivered")
      expect(json_response["data"]["delivery_end_time"]).to be_present
      expect(json_response["data"]["actual_delivery_time"]).to be_present
    end
  end

  include_examples 'request_shared_spec', 'delivery_orders', 11
end
