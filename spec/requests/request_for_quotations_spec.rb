require 'rails_helper'

RSpec.describe 'RequestForQuotations', type: :request do
  let(:valid_attributes) do
    {
      user_id: create(:user).id,
      status: 0,
      notes: "Sample RFQ notes",
    }
  end

  let(:invalid_attributes) do
    {
      user_id: nil,
      status: nil
    }
  end

  let(:new_attributes) do
    {
      notes: "Updated RFQ notes"
    }
  end

  include_examples 'request_shared_spec', 'request_for_quotations', 7
end
