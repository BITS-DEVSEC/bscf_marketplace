class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :sku, :name, :description, :category_id, :base_price,
             :created_at, :updated_at, :thumbnail_url, :image_urls

  belongs_to :category, class_name: "Bscf::Core::Category"

  def thumbnail_url
    if object.thumbnail.attached?
      rails_blob_url(object.thumbnail, host: 'snf.bitscollege.edu.et', protocol: 'https', script_name: '/marketplace')
    end
  end

  def image_urls
    if object.images.attached?
      object.images.map { |image| rails_blob_url(image, host: 'snf.bitscollege.edu.et', protocol: 'https', script_name: '/marketplace') }
    else
      []
    end
  end
end
