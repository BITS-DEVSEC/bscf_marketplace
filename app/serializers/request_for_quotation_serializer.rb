class RequestForQuotationSerializer < ActiveModel::Serializer
  attributes :id, :status, :notes, :created_at, :updated_at

  belongs_to :user
  has_many :rfq_items
end
