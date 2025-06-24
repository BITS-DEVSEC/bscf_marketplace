class BusinessDocumentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :user_id,
             :document_number,
             :document_name,
             :document_description,
             :verified_at,
             :is_verified,
             :created_at,
             :updated_at,
             :file_url
  belongs_to :user

  def file_url
    return nil unless object.file.attached?
    rails_blob_url(object.file, only_path: true)
  end
end
