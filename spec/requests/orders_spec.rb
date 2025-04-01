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
      let!(:order_items) { user_orders.map { |order| create_list(:order_item, 2, order: order) }.flatten }
      let!(:other_user_orders) { create_list(:order, 2) }

      it "returns only the current user orders and their items" do
        get "/orders/my_orders", headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["orders"].length).to eq(3)
        expect(json_response["orders"].pluck("ordered_by_id")).to all(eq(user.id))
        expect(json_response["order_items"].length).to eq(6) # 3 orders × 2 items each


        returned_order_ids = json_response["order_items"].pluck("order_id").uniq.sort
        expect(returned_order_ids).to match_array(user_orders.pluck(:id))
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
  describe "POST /orders/create_with_items" do
    let!(:user) { create(:user) }
    let!(:role) { create(:role) }
    let!(:user_role) { create(:user_role, user: user, role: role) }
    let!(:token) { Bscf::Core::TokenService.new.encode({ user: { id: user.id }, role: { name: role.name } }) }
    let!(:headers) do
      { Authorization: "Bearer #{token}" }
    end

    let(:ordered_to) { create(:user) }
    let(:product) { create(:product) }

    context "with valid parameters" do
      let(:valid_order_params) do
        {
          order: {
            ordered_to_id: ordered_to.id,
            order_type: 0,
            status: 0,
            total_amount: 3000.0
          },
          order_items: [
            {
              product_id: product.id,
              quantity: 2,
              unit_price: 1500.0,
              subtotal: 3000.0
            }
          ]
        }
      end

      it "creates a new order with items" do
        expect {
          post create_with_items_orders_path,
            params: valid_order_params,
            headers: headers,
            as: :json
        }.to change(Bscf::Core::Order, :count).by(1)
          .and change(Bscf::Core::OrderItem, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)

        expect(json_response["success"]).to be true
        expect(json_response["order"]["ordered_by_id"]).to eq(user.id)
        expect(json_response["order_items"].length).to eq(1)
        expect(json_response["order_items"][0]["product_id"]).to eq(product.id)
      end
    end

    context "with invalid parameters" do
      let(:invalid_order_params) do
        {
          order: {
            ordered_to_id: nil,
            order_type: nil,
            status: nil,
            total_amount: nil
          },
          order_items: [
            {
              product_id: nil,
              quantity: nil,
              unit_price: nil,
              subtotal: nil
            }
          ]
        }
      end

      it "does not create order and returns error" do
        expect {
          post create_with_items_orders_path,
            params: invalid_order_params,
            headers: headers,
            as: :json
        }.to change(Bscf::Core::Order, :count).by(0)
          .and change(Bscf::Core::OrderItem, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be false
        expect(json_response["errors"]).to be_present
      end
    end

    context "when user is not authenticated" do
      it "returns unauthorized status" do
        post create_with_items_orders_path,
          params: { order: {}, order_items: [] },
          as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
