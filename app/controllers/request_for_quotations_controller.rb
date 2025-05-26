class RequestForQuotationsController < ApplicationController
  include Common
  include CreatableWithItems
  before_action :is_authenticated

  
  def index
    @rfqs = Bscf::Core::RequestForQuotation.includes(:user, rfq_items: :product).all
  
    if @rfqs.empty?
      render json: { success: false, error: "No RFQs found" }, status: :not_found
      return
    end
  
    enriched_rfqs = @rfqs.map do |rfq|
      rfq_items = rfq.rfq_items.map do |item|
        item.attributes.merge(product: item.product&.attributes)
      end
  
      rfq.attributes.merge(
        user: rfq.user&.attributes,
        rfq_items: rfq_items
      )
    end
  
    render json: {
      success: true,
      data: enriched_rfqs
    }, status: :ok
  end
  

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

  def permitted_item_params
    [ :product_id, :quantity, :notes ]
  end
end
