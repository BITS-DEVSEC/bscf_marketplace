class BusinessDocumentsController < ApplicationController
  include Common
  before_action :is_authenticated
  before_action :is_admin, only: [ :get_by_user ]

  def my_business_documents
    business = Bscf::Core::Business.find_by(user: current_user)
    unless business
      render json: { success: false, error: "No business found for current user" }, status: :not_found
      return
    end

    @documents = Bscf::Core::BusinessDocument.where(business: business)
    if @documents.empty?
      render json: { success: false, error: "No documents found" }, status: :not_found
      return
    end
    render json: { success: true, data: @documents }, status: :ok
  end

  def get_by_user
    user = Bscf::Core::User.find_by(id: params[:user_id])
    unless user
      render json: { success: false, error: "User not found" }, status: :not_found
      return
    end

    business = Bscf::Core::Business.find_by(user: user)
    unless business
      render json: { success: false, error: "No business found for this user" }, status: :not_found
      return
    end

    @documents = Bscf::Core::BusinessDocument.where(business: business)
    render json: {
      success: true,
      business: business,
      documents: @documents
    }, status: :ok
  end

  private

  def is_admin
    unless current_user.roles.name == "admin"
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
      :business_id,
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
