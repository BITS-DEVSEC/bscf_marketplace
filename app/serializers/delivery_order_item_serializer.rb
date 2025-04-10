class DeliveryOrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :status, :notes, :created_at, :updated_at, :delivery_order_id
  belongs_to :order_item
  belongs_to :product
end
