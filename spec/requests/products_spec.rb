require 'rails_helper'

RSpec.describe 'Products', type: :request do
  let(:valid_attributes) do
    {
      sku: Faker::Alphanumeric.unique.alphanumeric(number: 10),
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph,
      category_id: create(:category).id,
      base_price: Faker::Commerce.price(range: 10..1000.0)
    }
  end

  let(:invalid_attributes) do
    {
      sku: nil,
      description: nil,
      category_id: create(:category).id
    }
  end

  let(:new_attributes) do
    {
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph,
      base_price: Faker::Commerce.price(range: 10..1000.0)
    }
  end

  include_examples 'request_shared_spec', 'products', 9
end
