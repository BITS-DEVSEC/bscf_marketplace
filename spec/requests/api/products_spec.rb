require 'swagger_helper'

RSpec.describe 'Products API', type: :request do
  path '/products' do
    get 'Lists all products' do
      tags 'Products'
      produces 'application/json'
      
      response '200', 'products found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              category_id: { type: :integer },
              price: { type: :number },
              quantity: { type: :integer },
              status: { type: :string },
              seller_id: { type: :integer },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: ['id', 'name', 'price', 'category_id', 'seller_id']
          }
        run_test!
      end
    end

    post 'Creates a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          category_id: { type: :integer },
          price: { type: :number },
          quantity: { type: :integer },
          status: { type: :string },
          seller_id: { type: :integer }
        },
        required: ['name', 'price', 'category_id', 'seller_id']
      }

      response '201', 'product created' do
        let(:product) { { name: 'New Product', price: 100.0, category_id: 1, seller_id: 1 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:product) { { name: nil } }
        run_test!
      end
    end
  end

  path '/products/{id}' do
    get 'Retrieves a product' do
      tags 'Products'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'product found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            category_id: { type: :integer },
            price: { type: :number },
            quantity: { type: :integer },
            status: { type: :string },
            seller_id: { type: :integer },
            created_at: { type: :string, format: :datetime },
            updated_at: { type: :string, format: :datetime }
          }
        let(:id) { 1 }
        run_test!
      end

      response '404', 'product not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a product' do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          category_id: { type: :integer },
          price: { type: :number },
          quantity: { type: :integer },
          status: { type: :string }
        }
      }

      response '200', 'product updated' do
        let(:id) { 1 }
        let(:product) { { name: 'Updated Product' } }
        run_test!
      end

      response '404', 'product not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete 'Deletes a product' do
      tags 'Products'
      parameter name: :id, in: :path, type: :integer

      response '204', 'product deleted' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'product not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/products/search' do
    get 'Search products' do
      tags 'Products'
      produces 'application/json'
      parameter name: :query, in: :query, type: :string, description: 'Search query'
      parameter name: :category_id, in: :query, type: :integer, required: false, description: 'Filter by category'
      parameter name: :min_price, in: :query, type: :number, required: false, description: 'Minimum price'
      parameter name: :max_price, in: :query, type: :number, required: false, description: 'Maximum price'

      response '200', 'search results' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              category_id: { type: :integer },
              price: { type: :number },
              quantity: { type: :integer },
              status: { type: :string },
              seller_id: { type: :integer },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            }
          }
        run_test!
      end
    end
  end
end