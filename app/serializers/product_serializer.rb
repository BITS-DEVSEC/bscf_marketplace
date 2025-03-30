class ProductSerializer < ActiveModel::Serializer
  attributes :id, :sku, :name, :description, :category_id, :base_price, :created_at, :updated_at
  # Add your attributes here

  belongs_to :category, class_name: "Bscf::Core::Category"
end
