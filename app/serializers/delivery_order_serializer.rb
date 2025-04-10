class DeliveryOrderSerializer < ActiveModel::Serializer
  attributes :id, :status, :pickup_location, :delivery_location, :delivery_notes, :created_at, :updated_at

  belongs_to :order
  belongs_to :driver, class_name: "Bscf::Core::User"
end
