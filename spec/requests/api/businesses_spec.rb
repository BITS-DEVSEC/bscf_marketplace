require 'swagger_helper'

RSpec.describe 'Businesses API', type: :request do
  path '/businesses' do
    get 'Lists all businesses' do
      tags 'Businesses'
      produces 'application/json'
      
      response '200', 'businesses found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              description: { type: :string },
              business_type: { type: :string },
              registration_number: { type: :string },
              tax_number: { type: :string },
              address: { type: :string },
              phone: { type: :string },
              email: { type: :string },
              website: { type: :string },
              status: { type: :string },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: ['id', 'name', 'business_type', 'registration_number']
          }
        run_test!
      end
    end

    post 'Creates a business' do
      tags 'Businesses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :business, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          business_type: { type: :string },
          registration_number: { type: :string },
          tax_number: { type: :string },
          address: { type: :string },
          phone: { type: :string },
          email: { type: :string },
          website: { type: :string }
        },
        required: ['name', 'business_type', 'registration_number']
      }

      response '201', 'business created' do
        let(:business) { { name: 'New Business', business_type: 'Corporation', registration_number: 'REG123' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:business) { { name: nil } }
        run_test!
      end
    end
  end

  path '/businesses/{id}' do
    get 'Retrieves a business' do
      tags 'Businesses'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'business found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            business_type: { type: :string },
            registration_number: { type: :string },
            tax_number: { type: :string },
            address: { type: :string },
            phone: { type: :string },
            email: { type: :string },
            website: { type: :string },
            status: { type: :string },
            created_at: { type: :string, format: :datetime },
            updated_at: { type: :string, format: :datetime }
          }
        let(:id) { 1 }
        run_test!
      end

      response '404', 'business not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a business' do
      tags 'Businesses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :business, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          business_type: { type: :string },
          tax_number: { type: :string },
          address: { type: :string },
          phone: { type: :string },
          email: { type: :string },
          website: { type: :string },
          status: { type: :string }
        }
      }

      response '200', 'business updated' do
        let(:id) { 1 }
        let(:business) { { name: 'Updated Business' } }
        run_test!
      end

      response '404', 'business not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/businesses/verify' do
    post 'Verify business registration' do
      tags 'Businesses'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :verification, in: :body, schema: {
        type: :object,
        properties: {
          registration_number: { type: :string },
          tax_number: { type: :string },
          documents: { type: :array, items: { type: :string, format: :binary } }
        },
        required: ['registration_number', 'documents']
      }

      response '200', 'verification successful' do
        let(:verification) { { registration_number: 'REG123', documents: ['doc1.pdf'] } }
        run_test!
      end

      response '422', 'invalid verification data' do
        let(:verification) { { registration_number: nil } }
        run_test!
      end
    end
  end
end