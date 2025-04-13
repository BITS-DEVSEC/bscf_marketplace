module Ransackable
  extend ActiveSupport::Concern

  class_methods do
    private

    def common_attributes
      %w[id created_at updated_at]
    end

    def base_namespace
      "Bscf::Core::"
    end

    def model_attributes_mapping
      @model_attributes_mapping ||= {
        "Product" => {
          attributes: %w[sku name description base_price category_id],
          associations: %w[category order_items quotation_items rfq_items]
        },
        "DeliveryOrder" => {
          attributes: %w[order_id driver_id dropoff_address_id pickup_address_id driver_phone buyer_phone seller_phone delivery_notes estimated_delivery_time delivery_start_time delivery_end_time actual_delivery_time delivery_price status],
          associations: %w[order driver dropoff_address pickup_address delivery_order_items]
        },
        "DeliveryOrderItem" => {
          attributes: %w[delivery_order_id order_item_id product_id quantity status notes],
          associations: %w[delivery_order order_item product]
        },
        "Category" => {
          attributes: %w[name description parent_id],
          associations: %w[products parent children]
        },
        "RequestForQuotation" => {
          attributes: %w[user_id status notes],
          associations: %w[user rfq_items quotations]
        },
        "RfqItem" => {
          attributes: %w[request_for_quotation_id product_id quantity notes],
          associations: %w[request_for_quotation product]
        },
        "Quotation" => {
          attributes: %w[request_for_quotation_id business_id price delivery_date valid_until status notes],
          associations: %w[request_for_quotation business quotation_items orders]
        },
        "QuotationItem" => {
          attributes: %w[quotation_id rfq_item_id product_id quantity unit_price unit subtotal],
          associations: %w[quotation rfq_item product]
        },
        "Order" => {
          attributes: %w[ordered_by_id ordered_to_id quotation_id order_type status total_amount],
          associations: %w[ordered_by ordered_to quotation order_items]
        },
        "OrderItem" => {
          attributes: %w[order_id product_id quotation_item_id quantity unit_price subtotal],
          associations: %w[order product quotation_item]
        }
      }.freeze
    end

    def model_key
      self.name.delete_prefix(base_namespace)
    end

    def model_config
      model_attributes_mapping[model_key] || { attributes: [], associations: [] }
    end

    public

    def ransackable_attributes(auth_object = nil)
      attributes = common_attributes + model_config[:attributes]
      Set.new(attributes).freeze & column_names
    end

    def ransackable_associations(auth_object = nil)
      associations = model_config[:associations]
      Set.new(associations).freeze & reflect_on_all_associations.map(&:name).map(&:to_s)
    end

    def ransackable_scopes(auth_object = nil)
      []
    end
  end
end
