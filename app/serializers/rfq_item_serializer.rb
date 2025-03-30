class RfqItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :notes, :created_at, :updated_at

  belongs_to :request_for_quotation
  belongs_to :product
end
