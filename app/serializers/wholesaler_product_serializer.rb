class WholesalerProductSerializer < ActiveModel::Serializer
  attributes :id, :minimum_order_quantity, :wholesale_price, :available_quantity,
             :status, :created_at, :updated_at

  belongs_to :business
  belongs_to :product
end
