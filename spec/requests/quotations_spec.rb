require 'rails_helper'

RSpec.describe 'Quotations', type: :request do
  let(:valid_attributes) do
    {
      request_for_quotation_id: create(:request_for_quotation).id,
      business_id: create(:business).id,
      price: 1500.50,
      delivery_date: Date.tomorrow,
      valid_until: 1.week.from_now,
      status: 0,
      notes: "Sample quotation notes",
    }
  end

  let(:invalid_attributes) do
    {
      request_for_quotation_id: nil,
      business_id: nil,
      price: nil,
      delivery_date: nil,
      valid_until: nil
    }
  end

  let(:new_attributes) do
    {
      price: 2000.00,
      delivery_date: 2.days.from_now,
      notes: "Updated quotation notes"
    }
  end

  include_examples 'request_shared_spec', 'quotations', 11
end
