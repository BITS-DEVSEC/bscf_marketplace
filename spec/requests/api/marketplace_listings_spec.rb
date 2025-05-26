require 'swagger_helper'

RSpec.describe 'Marketplace Listings API', type: :request do
  path '/marketplace_listings' do
    get 'Lists all marketplace listings' do
      tags 'Marketplace Listings'
      produces 'application/json'
      
      response '200', 'marketplace listings found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              description: { type: :string },
              price: { type: :number },
              quantity: { type: :integer },
              status: { type: :string },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: ['id', 'title', 'price', 'status']
          }
        run_test!
      end
    end

    post 'Creates a marketplace listing' do
      tags 'Marketplace Listings'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :marketplace_listing, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          price: { type: :number },
          quantity: { type: :integer },
          status: { type: :string }
        },
        required: ['title', 'price']
      }

      response '201', 'marketplace listing created' do
        let(:marketplace_listing) { { title: 'New Listing', price: 100.0 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:marketplace_listing) { { title: nil } }
        run_test!
      end
    end
  end

  path '/marketplace_listings/{id}' do
    get 'Retrieves a marketplace listing' do
      tags 'Marketplace Listings'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'marketplace listing found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            description: { type: :string },
            price: { type: :number },
            quantity: { type: :integer },
            status: { type: :string },
            created_at: { type: :string, format: :datetime },
            updated_at: { type: :string, format: :datetime }
          }
        let(:id) { 1 }
        run_test!
      end

      response '404', 'marketplace listing not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/marketplace_listings/my_marketplace_listings' do
    get 'Lists user\'s marketplace listings' do
      tags 'Marketplace Listings'
      produces 'application/json'
      
      response '200', 'user\'s marketplace listings found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              description: { type: :string },
              price: { type: :number },
              quantity: { type: :integer },
              status: { type: :string },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            }
          }
        run_test!
      end
    end
  end
end