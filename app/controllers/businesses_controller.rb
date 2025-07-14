class BusinessesController < ApplicationController
  include Common
  before_action :is_authenticated

  def my_business
    @business = Bscf::Core::Business.find_by(user: current_user)
    unless @business
      render json: { success: false, error: "No business found for current user" }, status: :not_found
      return
    end
    render json: { success: true, data: @business }, status: :ok
  end

  def has_business
    @business = Bscf::Core::Business.find_by(user: current_user)
    if @business
      render json: { success: true, has_business: true, business: @business }, status: :ok
    else
      render json: { success: true, has_business: false }, status: :ok
    end
  end

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :business_name,
      :business_type,
      :tin_number,
      :user_id,
      :verification_status,
      :verified_at
    ]
  end

  def model_class
    Bscf::Core::Business
  end

  def validate_record
    return true if @record.valid?
    render json: { success: false, error: @record.errors.full_messages }, status: :unprocessable_entity
    false
  end
end
