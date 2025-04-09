require 'rails_helper'

RSpec.describe 'WholesalerProducts', type: :request do
  let(:valid_attributes) do
    {
      business_id: create(:business, business_type: :wholesaler).id,
      product_id: create(:product).id,
      minimum_order_quantity: 10,
      wholesale_price: 100.50,
      available_quantity: 1000,
      status: 0
    }
  end

  let(:invalid_attributes) do
    {
      business_id: nil,
      product_id: nil,
      minimum_order_quantity: nil,
      wholesale_price: nil,
      available_quantity: nil
    }
  end

  let(:new_attributes) do
    {
      minimum_order_quantity: 20,
      wholesale_price: 95.75,
      available_quantity: 1500
    }
  end

  include_examples 'request_shared_spec', 'wholesaler_products', 9

  describe "POST /find_best_wholesalers" do
    let!(:user) { create(:user) }
    let!(:role) { create(:role) }
    let!(:user_role) { create(:user_role, user: user, role: role) }
    let!(:token) { Bscf::Core::TokenService.new.encode({ user: { id: user.id }, role: { name: role.name } }) }
    let!(:headers) do
      { Authorization: "Bearer #{token}" }
    end

    let!(:products) { create_list(:product, 3) }
    let!(:businesses) do
      4.times.map do
        create(:business, business_type: :wholesaler)
      end
    end

    before do
      businesses.each do |business|
        products.each do |product|
          create(:wholesaler_product,
                business: business,
                product: product,
                wholesale_price: rand(80..120),
                available_quantity: rand(500..1500),
                status: :active)
        end
      end
    end

    it "returns the best 3 wholesalers for given products" do
      post "/wholesaler_products/find_best_wholesalers",
          params: { payload: { product_ids: products.pluck(:id) } },
          headers: headers

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response["success"]).to be true
      expect(json_response["wholesalers"].length).to eq(3)
      expect(json_response["wholesalers"].first).to include(
        "business_id",
        "name",
        "average_price",
        "total_available_quantity"
      )
    end
  end
end
