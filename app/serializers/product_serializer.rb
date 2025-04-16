class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :sku, :name, :description, :category_id, :base_price,
             :created_at, :updated_at, :thumbnail_url, :image_urls

  belongs_to :category, class_name: "Bscf::Core::Category"

  def thumbnail_url
    if object.thumbnail.attached?
      ActiveStorage::Current.set(url_options: { host: 'snf.bitscollege.edu.et', protocol: 'https', script_name: '/marketplace' }) do
        object.thumbnail.url
      end
    end
  end

  def image_urls
    if object.images.attached?
      ActiveStorage::Current.set(url_options: { host: 'snf.bitscollege.edu.et', protocol: 'https', script_name: '/marketplace' }) do
        object.images.map(&:url)
      end
    else
      []
    end
  end
end
