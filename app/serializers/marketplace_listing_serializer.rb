class MarketplaceListingSerializer < ActiveModel::Serializer
  attributes :id, :listing_type, :status, :allow_partial_match, :expires_at, :price
  belongs_to :user
  belongs_to :address
  belongs_to :product
end
