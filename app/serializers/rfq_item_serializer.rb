class RfqItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :notes, :product_id, :created_at, :updated_at

  belongs_to :product
  belongs_to :request_for_quotation
end
