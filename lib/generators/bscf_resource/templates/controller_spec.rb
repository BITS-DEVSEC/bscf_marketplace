require "rails_helper"

RSpec.describe "<%= class_name.pluralize %>", type: :request do
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

  include_examples "request_shared_spec", "<%= plural_name %>", 7
end
