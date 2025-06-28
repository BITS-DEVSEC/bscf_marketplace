class QuotationsController < ApplicationController
  include Common
  include CreatableWithItems
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

  def create_order
    @quotation = Bscf::Core::Quotation.find(params[:id])

    order_params = {
      ordered_by_id: current_user.id,
      ordered_to_id: @quotation.business.user_id,
      quotation_id: @quotation.id,
      order_type: :quotation_based,
      status: :pending,
      total_amount: @quotation.price
    }

    @order = Bscf::Core::Order.new(order_params)

    if @order.save
      # Create order items from quotation items
      @quotation.quotation_items.each do |quotation_item|
        order_item_params = {
          order_id: @order.id,
          product_id: quotation_item.product_id,
          quotation_item_id: quotation_item.id,
          quantity: quotation_item.quantity,
          unit_price: quotation_item.unit_price,
          subtotal: quotation_item.subtotal
        }

        Bscf::Core::OrderItem.create!(order_item_params)
      end

      render json: {
        success: true,
        message: "Order created successfully",
        data: serialize(@order, serializer: OrderSerializer)
      }, status: :created
    else
      render json: {
        success: false,
        error: @order.errors.full_messages
      }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "Quotation not found" }, status: :not_found
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  def includes
    [ :request_for_quotation, :business, :quotation_items ]
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

  def permitted_item_params
    [
      :rfq_item_id,
      :product_id,
      :quantity,
      :unit_price,
      :unit,
      :subtotal
    ]
  end
end
