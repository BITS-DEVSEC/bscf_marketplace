require 'swagger_helper'

RSpec.describe 'Quotations API', type: :request do
  path '/quotations' do
    get 'Lists all quotations' do
      tags 'Quotations'
      produces 'application/json'
      
      response '200', 'quotations found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              rfq_id: { type: :integer },
              seller_id: { type: :integer },
              price_per_unit: { type: :number },
              total_price: { type: :number },
              delivery_time: { type: :integer },
              validity_period: { type: :integer },
              status: { type: :string },
              notes: { type: :string },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            },
            required: ['id', 'rfq_id', 'seller_id', 'price_per_unit', 'total_price']
          }
        run_test!
      end
    end

    post 'Creates a quotation' do
      tags 'Quotations'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :quotation, in: :body, schema: {
        type: :object,
        properties: {
          rfq_id: { type: :integer },
          price_per_unit: { type: :number },
          delivery_time: { type: :integer },
          validity_period: { type: :integer },
          notes: { type: :string }
        },
        required: ['rfq_id', 'price_per_unit']
      }

      response '201', 'quotation created' do
        let(:quotation) { { rfq_id: 1, price_per_unit: 100.0 } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:quotation) { { rfq_id: nil } }
        run_test!
      end
    end
  end

  path '/quotations/{id}' do
    get 'Retrieves a quotation' do
      tags 'Quotations'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'quotation found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            rfq_id: { type: :integer },
            seller_id: { type: :integer },
            price_per_unit: { type: :number },
            total_price: { type: :number },
            delivery_time: { type: :integer },
            validity_period: { type: :integer },
            status: { type: :string },
            notes: { type: :string },
            created_at: { type: :string, format: :datetime },
            updated_at: { type: :string, format: :datetime }
          }
        let(:id) { 1 }
        run_test!
      end

      response '404', 'quotation not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a quotation' do
      tags 'Quotations'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :quotation, in: :body, schema: {
        type: :object,
        properties: {
          price_per_unit: { type: :number },
          delivery_time: { type: :integer },
          validity_period: { type: :integer },
          status: { type: :string },
          notes: { type: :string }
        }
      }

      response '200', 'quotation updated' do
        let(:id) { 1 }
        let(:quotation) { { price_per_unit: 150.0 } }
        run_test!
      end

      response '404', 'quotation not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete 'Deletes a quotation' do
      tags 'Quotations'
      parameter name: :id, in: :path, type: :integer

      response '204', 'quotation deleted' do
        let(:id) { 1 }
        run_test!
      end

      response '404', 'quotation not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/quotations/my_quotations' do
    get 'Lists seller\'s quotations' do
      tags 'Quotations'
      produces 'application/json'
      
      response '200', 'seller\'s quotations found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              rfq_id: { type: :integer },
              seller_id: { type: :integer },
              price_per_unit: { type: :number },
              total_price: { type: :number },
              delivery_time: { type: :integer },
              validity_period: { type: :integer },
              status: { type: :string },
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