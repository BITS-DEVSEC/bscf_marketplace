class QuotationSerializer < ActiveModel::Serializer
  attributes :id, :price, :delivery_date, :valid_until, :status, :notes, :created_at, :updated_at
  belongs_to :request_for_quotation
  belongs_to :business
  has_many :quotation_items
end
