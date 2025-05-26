require 'swagger_helper'

RSpec.describe 'RFQs API', type: :request do
  path '/rfqs' do
    get 'Lists all RFQs' do
      tags 'RFQs'
      produces 'application/json'
      
      response '200', 'rfqs found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              description: { type: :string },
              buyer_id: { type: :integer },
              product_id: { type: :integer },
              quantity: { type: :integer },
              status: { type: :string },
              deadline: { type: :string, format: :datetime },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: ['id', 'title', 'buyer_id', 'product_id', 'quantity']
          }
        run_test!
      end
    end

    post 'Creates an RFQ' do
      tags 'RFQs'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :rfq, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          product_id: { type: :integer },
          quantity: { type: :integer },
          deadline: { type: :string, format: :datetime }
        },
        required: ['title', 'product_id', 'quantity']
      }

      response '201', 'rfq created' do
        let(:rfq) { { title: 'New RFQ', product_id: 1, quantity: 10 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:rfq) { { title: nil } }
        run_test!
      end
    end
  end

  path '/rfqs/{id}' do
    get 'Retrieves an RFQ' do
      tags 'RFQs'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'rfq found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            description: { type: :string },
            buyer_id: { type: :integer },
            product_id: { type: :integer },
            quantity: { type: :integer },
            status: { type: :string },
            deadline: { type: :string, format: :datetime },
            created_at: { type: :string, format: :datetime },
            updated_at: { type: :string, format: :datetime }
          }
        let(:id) { 1 }
        run_test!
      end

      response '404', 'rfq not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates an RFQ' do
      tags 'RFQs'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :rfq, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          quantity: { type: :integer },
          deadline: { type: :string, format: :datetime },
          status: { type: :string }
        }
      }

      response '200', 'rfq updated' do
        let(:id) { 1 }
        let(:rfq) { { title: 'Updated RFQ' } }
        run_test!
      end

      response '404', 'rfq not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete 'Deletes an RFQ' do
      tags 'RFQs'
      parameter name: :id, in: :path, type: :integer

      response '204', 'rfq deleted' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'rfq not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/rfqs/my_rfqs' do
    get 'Lists user\'s RFQs' do
      tags 'RFQs'
      produces 'application/json'
      
      response '200', 'user\'s rfqs found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              description: { type: :string },
              buyer_id: { type: :integer },
              product_id: { type: :integer },
              quantity: { type: :integer },
              status: { type: :string },
              deadline: { type: :string, format: :datetime },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            }
          }
        run_test!
      end
    end
  end
end