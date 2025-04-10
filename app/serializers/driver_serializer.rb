class DriverSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :middle_name, :last_name, :phone_number
end
