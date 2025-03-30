class QuotationItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :unit_price, :unit, :subtotal, :created_at, :updated_at
  belongs_to :quotation
  belongs_to :rfq_item
  belongs_to :product
end
