class BusinessDocumentsController < ApplicationController
  include Common
  before_action :is_authenticated

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

  private

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
