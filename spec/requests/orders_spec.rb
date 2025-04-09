require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  let(:valid_attributes) do
    {
      ordered_to_id: create(:user).id,
      quotation_id: create(:quotation).id,
      order_type: 0,
      status: 0,
      total_amount: 1500.50
    }
  end

  let(:invalid_attributes) do
    {
      ordered_to_id: nil,
      order_type: nil,
      status: nil,
      total_amount: nil
    }
  end

  context "with valid parameters" do
    let(:valid_order_params) do
      {
        payload: {
          ordered_to_id: ordered_to.id,
          order_type: 0,
          status: 0,
          total_amount: 3000.0
        },
        order_items_attributes: [
          {
            product_id: product.id,
            quantity: 2.0,
            unit_price: 1500.0,
            subtotal: 3000.0
          }
        ]
      }
    end
  end

  context "with invalid parameters" do
    let(:invalid_order_params) do
      {
        payload: {
          ordered_to_id: nil,
          order_type: nil,
          status: nil,
          total_amount: nil
        },
        order_items_attributes: [
          {
            product_id: nil,
            quantity: nil,
            unit_price: nil,
            subtotal: nil
          }
        ]
      }
    end
  end
end
