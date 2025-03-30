require 'rails_helper'

RSpec.describe 'RfqItems', type: :request do
  let(:valid_attributes) do
    {
      request_for_quotation_id: create(:request_for_quotation).id,
      product_id: create(:product).id,
      quantity: 10.5,
      notes: "Sample RFQ item notes"
    }
  end

  let(:invalid_attributes) do
    {
      request_for_quotation_id: nil,
      product_id: nil,
      quantity: nil
    }
  end

  let(:new_attributes) do
    {
      quantity: 15.0,
      notes: "Updated RFQ item notes"
    }
  end

  include_examples 'request_shared_spec', 'rfq_items', 7
end