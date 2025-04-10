require 'rails_helper'

RSpec.describe 'DeliveryOrders', type: :request do
  let(:valid_attributes) do
    {
      order_id: create(:order).id,
      status: 0,
      pickup_location: "Warehouse A",
      delivery_location: "Customer Address",
      delivery_notes: "Handle with care"
    }
  end

  let(:invalid_attributes) do
    {
      order_id: nil,
      status: nil,
      pickup_location: nil,
      delivery_location: nil
    }
  end

  let(:new_attributes) do
    {
      status: 1,
      delivery_notes: "Updated delivery instructions"
    }
  end

  describe "PUT /accept_delivery" do
    let(:user) { create(:user) }
    let(:delivery_order) { create(:delivery_order) }

    before do
      sign_in_user(user)
    end

    it "accepts the delivery order and assigns it to the driver" do
      put accept_delivery_delivery_order_path(delivery_order), headers: auth_headers

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response["success"]).to be true
      expect(json_response["data"]["driver_id"]).to eq(user.id)
      expect(json_response["data"]["status"]).to eq("assigned")
    end
  end

  include_examples 'request_shared_spec', 'delivery_orders', 8
end
