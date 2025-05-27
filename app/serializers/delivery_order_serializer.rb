class DeliveryOrderSerializer < ActiveModel::Serializer
  attributes :id, :driver_phone, :buyer_phone, :seller_phone, :delivery_notes, :delivery_price,
             :estimated_delivery_time, :delivery_start_time, :delivery_end_time,
             :actual_delivery_time, :status, :created_at, :updated_at

  has_many :orders
  belongs_to :dropoff_address, class_name: "Bscf::Core::Address"
  belongs_to :pickup_address, class_name: "Bscf::Core::Address"
  belongs_to :driver, class_name: "Bscf::Core::User"
  has_many :delivery_order_items
end
