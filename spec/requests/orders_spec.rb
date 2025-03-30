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

  include_examples 'request_shared_spec', 'orders', 9
end
