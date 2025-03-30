class OrderSerializer < ActiveModel::Serializer
  attributes :id, :order_type, :status, :total_amount, :created_at, :updated_at
  belongs_to :ordered_by, class_name: "User"
  belongs_to :ordered_to, class_name: "User"
  belongs_to :quotation
end
