class RequestForQuotationsController < ApplicationController
  include Common
  before_action :is_authenticated

  def my_rfqs
    @rfqs = Bscf::Core::RequestForQuotation.where(user: current_user)
    if @rfqs.empty?
      render json: { success: false, error: "No RFQs found" }, status: :not_found
      return
    end
    @rfq_items = Bscf::Core::RfqItem.where(request_for_quotation_id: @rfqs.pluck(:id))
    render json: { success: true, rfqs: @rfqs, rfq_items: @rfq_items, status: :ok }
  end

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [ :user_id, :status, :notes ]
  end
end
