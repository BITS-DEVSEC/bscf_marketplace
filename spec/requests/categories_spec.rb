require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:valid_attributes) do
      {
        name: Faker::Name.name,
        description: Faker::Lorem.word,
        parent_id: create(:category).id
      }
    end

    let(:invalid_attributes) do
      {
        name: nil,
        description: Faker::Lorem.word,
        parent_id: nil
      }
    end

    let(:new_attributes) do
      {
        name: Faker::Name.name,
        description: Faker::Lorem.word,
        parent_id: create(:category).id
      }
    end

    it_behaves_like "request_shared_spec", "categories", 7
end
