require 'rails_helper'

RSpec.describe 'QuotationItems', type: :request do
  let(:valid_attributes) do
    {
      quotation_id: create(:quotation).id,
      rfq_item_id: create(:rfq_item).id,
      product_id: create(:product).id,
      quantity: 5,
      unit_price: 300.10,
      unit: 0,
      subtotal: 1500.50
    }
  end

  let(:invalid_attributes) do
    {
      quotation_id: nil,
      rfq_item_id: nil,
      product_id: nil,
      quantity: nil,
      unit_price: nil,
      unit: nil
    }
  end

  let(:new_attributes) do
    {
      quantity: 10,
      unit_price: 250.75,
      subtotal: 2507.50
    }
  end

  include_examples 'request_shared_spec', 'quotation_items', 10
end
