class BusinessDocumentsController < ApplicationController
  include Common
  before_action :is_authenticated
  before_action :is_admin, only: [ :get_by_user ]

  def my_business_documents
    documents = Bscf::Core::BusinessDocument.where(user: current_user)

    if documents.empty?
      render json: { success: false, error: "No documents found" }, status: :not_found
    else
      render json: { success: true, data: documents }, status: :ok
    end
  end

  def get_by_user
    user = Bscf::Core::User.find_by(id: params[:user_id])
    unless user
      render json: { success: false, error: "User not found" }, status: :not_found
      return
    end

    documents = Bscf::Core::BusinessDocument.where(user: user)

    render json: {
      success: true,
      user: user,
      documents: ActiveModelSerializers::SerializableResource.new(documents)
    }, status: :ok
  end

  private

  def is_admin
    unless current_user.roles.exists?(name: "admin")
      render json: { success: false, error: "Unauthorized access" }, status: :forbidden
      return false
    end
    true
  end

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :user_id,
      :document_type,
      :document_number,
      :document_name,
      :document_description,
      :file,
      :is_verified,
      :verified_at
    ]
  end

  def validate_record
    return true if @record.valid?
    render json: { success: false, error: @record.errors.full_messages }, status: :unprocessable_entity
    false
  end
end
