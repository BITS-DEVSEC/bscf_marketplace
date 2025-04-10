require 'rails_helper'

RSpec.describe "Vehicles", type: :request do
  let(:valid_attributes) do
    {
      plate_number: "ABC123",
      vehicle_type: "Pickup",
      brand: "Toyota",
      model: "Hilux",
      year: 2020,
      color: "White",
      driver_id: create(:user).id
    }
  end

  let(:invalid_attributes) do
    {
      plate_number: nil,
      vehicle_type: nil,
      brand: nil,
      model: nil,
      year: nil,
      color: nil
    }
  end

  let(:new_attributes) do
    {
      color: "Black"
    }
  end

  include_examples "request_shared_spec", "vehicles", 10
end
