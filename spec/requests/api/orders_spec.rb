require 'swagger_helper'

RSpec.describe 'Orders API', type: :request do
  path '/orders' do
    get 'Lists all orders' do
      tags 'Orders'
      produces 'application/json'
      
      response '200', 'orders found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              buyer_id: { type: :integer },
              seller_id: { type: :integer },
              quotation_id: { type: :integer },
              total_amount: { type: :number },
              status: { type: :string },
              payment_status: { type: :string },
              delivery_address: { type: :string },
              delivery_date: { type: :string, format: :datetime },
              notes: { type: :string },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: ['id', 'buyer_id', 'seller_id', 'quotation_id', 'total_amount']
          }
        run_test!
      end
    end

    post 'Creates an order' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          quotation_id: { type: :integer },
          delivery_address: { type: :string },
          delivery_date: { type: :string, format: :datetime },
          notes: { type: :string }
        },
        required: ['quotation_id', 'delivery_address']
      }

      response '201', 'order created' do
        let(:order) { { quotation_id: 1, delivery_address: '123 Main St' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:order) { { quotation_id: nil } }
        run_test!
      end
    end
  end

  path '/orders/{id}' do
    get 'Retrieves an order' do
      tags 'Orders'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'order found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            buyer_id: { type: :integer },
            seller_id: { type: :integer },
            quotation_id: { type: :integer },
            total_amount: { type: :number },
            status: { type: :string },
            payment_status: { type: :string },
            delivery_address: { type: :string },
            delivery_date: { type: :string, format: :datetime },
            notes: { type: :string },
            created_at: { type: :string, format: :datetime },
            updated_at: { type: :string, format: :datetime }
          }
        let(:id) { 1 }
        run_test!
      end

      response '404', 'order not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates an order' do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :order, in: :body, schema: {
        type: :object,
        properties: {
          status: { type: :string },
          payment_status: { type: :string },
          delivery_address: { type: :string },
          delivery_date: { type: :string, format: :datetime },
          notes: { type: :string }
        }
      }

      response '200', 'order updated' do
        let(:id) { 1 }
        let(:order) { { status: 'processing' } }
        run_test!
      end

      response '404', 'order not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/orders/my_orders' do
    get 'Lists user\'s orders' do
      tags 'Orders'
      produces 'application/json'
      
      response '200', 'user\'s orders found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              buyer_id: { type: :integer },
              seller_id: { type: :integer },
              quotation_id: { type: :integer },
              total_amount: { type: :number },
              status: { type: :string },
              payment_status: { type: :string },
              delivery_address: { type: :string },
              delivery_date: { type: :string, format: :datetime },
              notes: { type: :string },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            }
          }
        run_test!
      end
    end
  end
end