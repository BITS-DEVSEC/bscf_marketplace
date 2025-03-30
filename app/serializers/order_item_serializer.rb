class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :unit_price, :subtotal, :created_at, :updated_at
  belongs_to :order
  belongs_to :product
  belongs_to :quotation_item
end
