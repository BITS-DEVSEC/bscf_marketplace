require 'rails_helper'

RSpec.describe "DeliveryOrderItems", type: :request do
  let(:valid_attributes) do
    {
      delivery_order_id: create(:delivery_order).id,
      order_item_id: create(:order_item).id,
      product_id: create(:product).id,
      quantity: 5,
      status: 0,
      notes: "Test notes"
    }
  end

  let(:invalid_attributes) do
    {
      delivery_order_id: nil,
      order_item_id: nil,
      product_id: nil,
      quantity: nil,
      status: nil
    }
  end

  let(:new_attributes) do
    {
      notes: "Updated notes"
    }
  end

  include_examples 'request_shared_spec', 'delivery_order_items', 9
end
