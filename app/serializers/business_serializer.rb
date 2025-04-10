class BusinessSerializer < ActiveModel::Serializer
  attributes :id,
             :business_name,
             :business_type,
             :tin_number,
             :user_id,
             :verification_status,
             :verified_at,
             :created_at,
             :updated_at
end
