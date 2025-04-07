class RequestForQuotationsController < ApplicationController
  include Common
  include CreatableWithItems
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

  def permitted_params
    [ :status, :notes ]
  end

  def permitted_item_params
    [ :product_id, :quantity, :notes ]
  end
end
