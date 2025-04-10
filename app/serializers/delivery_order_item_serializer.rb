class DeliveryOrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :status, :notes, :created_at, :updated_at
  belongs_to :delivery_order
  belongs_to :order_item
  belongs_to :product
end