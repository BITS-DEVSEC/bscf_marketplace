class QuotationsController < ApplicationController
  include Common
  before_action :is_authenticated

  def my_quotations
    business = Bscf::Core::Business.find_by(user: current_user)
    unless business
      render json: { success: false, error: "No business found for current user" }, status: :not_found
      return
    end

    @quotations = Bscf::Core::Quotation.where(business: business)
    if @quotations.empty?
      render json: { success: false, error: "No quotations found" }, status: :not_found
      return
    end
    @quotation_items = Bscf::Core::QuotationItem.where(quotation_id: @quotations.pluck(:id))
    render json: { success: true, quotations: @quotations, quotation_items: @quotation_items, status: :ok }
  end

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :request_for_quotation_id,
      :business_id,
      :price,
      :delivery_date,
      :valid_until,
      :status,
      :notes
    ]
  end
end
