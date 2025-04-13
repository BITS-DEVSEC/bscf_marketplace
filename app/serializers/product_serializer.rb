class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :sku, :name, :description, :category_id, :base_price,
             :created_at, :updated_at, :thumbnail_url, :image_urls

  belongs_to :category, class_name: "Bscf::Core::Category"

  def thumbnail_url
    if object.thumbnail.attached?
      rails_blob_url(object.thumbnail, only_path: true)
    end
  end

  def image_urls
    if object.images.attached?
      object.images.map { |image| rails_blob_url(image, only_path: true) }
    else
      []
    end
  end
end
