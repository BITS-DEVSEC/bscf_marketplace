class VehicleSerializer < ActiveModel::Serializer
  attributes :id,
             :plate_number,
             :vehicle_type,
             :brand,
             :model,
             :year,
             :color,
             :created_at,
             :updated_at

  belongs_to :driver, serializer: DriverSerializer
end
