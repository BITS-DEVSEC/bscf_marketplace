require 'swagger_helper'

RSpec.describe 'Categories API', type: :request do
  path '/categories' do
    get 'Lists all categories' do
      tags 'Categories'
      produces 'application/json'
      
      response '200', 'categories found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              parent_id: { type: :integer },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: ['id', 'name']
          }
        run_test!
      end
    end

    post 'Creates a category' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          parent_id: { type: :integer }
        },
        required: ['name']
      }

      response '201', 'category created' do
        let(:category) { { name: 'New Category' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:category) { { name: nil } }
        run_test!
      end
    end
  end

  path '/categories/{id}' do
    get 'Retrieves a category' do
      tags 'Categories'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'category found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            parent_id: { type: :integer },
            created_at: { type: :string, format: :datetime },
            updated_at: { type: :string, format: :datetime }
          }
        let(:id) { 1 }
        run_test!
      end

      response '404', 'category not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a category' do
      tags 'Categories'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :category, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          parent_id: { type: :integer }
        }
      }

      response '200', 'category updated' do
        let(:id) { 1 }
        let(:category) { { name: 'Updated Category' } }
        run_test!
      end

      response '404', 'category not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete 'Deletes a category' do
      tags 'Categories'
      parameter name: :id, in: :path, type: :integer

      response '204', 'category deleted' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'category not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end