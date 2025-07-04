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
    
    ActiveStorage::Current.set(url_options: { host: "snf.bitscollege.edu.et", protocol: "https", script_name: "/marketplace" }) do
      object.file.url
    end
  end
end
