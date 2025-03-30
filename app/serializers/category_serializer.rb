class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :parent_id, :created_at, :updated_at

  belongs_to :parent, class_name: "BscfCore::Category", optional: true
end
