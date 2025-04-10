require "rails_helper"

RSpec.describe "DeliveryOrderItems", type: :request do
  let(:valid_attributes) do
    {
      # Add your valid attributes here
    }
  end

  let(:invalid_attributes) do
    {
      # Add your invalid attributes here
    }
  end

  let(:new_attributes) do
    {
      # Add your new attributes here
    }
  end

  include_examples "request_shared_spec", "delivery_order_items", 7
end
