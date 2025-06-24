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
    direction = params[:direction]
    unless [ "in", "out" ].include?(direction)
      render json: { success: false, error: "Invalid direction. Must be 'in' or 'out'" }, status: :bad_request
      return
    end

    business = Bscf::Core::Business.find_by(user: current_user)
    unless business
      render json: { success: false, error: "No business found for current user" }, status: :not_found
      return
    end

    @rfqs = if direction == "out"
              Bscf::Core::RequestForQuotation.where(user: current_user)
    else
              Bscf::Core::RequestForQuotation.joins(:rfq_items)
                .joins("INNER JOIN products ON rfq_items.product_id = products.id")
                .where(products: { business_id: business.id })
                .distinct
    end

    if @rfqs.empty?
      render json: { success: false, error: "No RFQs found" }, status: :not_found
      return
    end

    @rfq_items = Bscf::Core::RfqItem.where(request_for_quotation_id: @rfqs.pluck(:id))

    render json: {
      success: true,
      rfqs: @rfqs,
      rfq_items: @rfq_items,
      direction: direction,
      status: :ok
    }
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
