class WholesalerProductsController < ApplicationController
  include Common
  before_action :is_authenticated

  def find_best_wholesalers
    product_ids = params[:payload][:product_ids]

    unless product_ids.present?
      render json: { success: false, error: "Product IDs are required" }, status: :bad_request
      return
    end

    businesses_with_all_products = Bscf::Core::Business
      .select('bscf_core_businesses.*,
               AVG(bscf_core_wholesaler_products.wholesale_price) as avg_price,
               SUM(bscf_core_wholesaler_products.available_quantity) as total_quantity')
      .joins("INNER JOIN bscf_core_wholesaler_products ON bscf_core_wholesaler_products.business_id = bscf_core_businesses.id")
      .where(
        business_type: :wholesaler,
        'bscf_core_wholesaler_products.product_id': product_ids,
        'bscf_core_wholesaler_products.status': Bscf::Core::WholesalerProduct.statuses[:active]
      )
      .group("bscf_core_businesses.id, bscf_core_businesses.business_name")
      .having("COUNT(DISTINCT bscf_core_wholesaler_products.product_id) = ?", product_ids.size)
      .order("avg_price ASC, total_quantity DESC")
      .limit(3)

    render json: {
      success: true,
      wholesalers: businesses_with_all_products.map do |business|
        {
          business_id: business.id,
          name: business.business_name,
          average_price: business.avg_price.to_f.round(2),
          total_available_quantity: business.total_quantity,
          products: Bscf::Core::WholesalerProduct
                            .where(business_id: business.id, product_id: product_ids)
                            .select(:id, :product_id, :wholesale_price, :available_quantity)
        }
      end
    }
  end

  def includes
    [ :business, product: [ :thumbnail_attachment, :images_attachments ] ]
  end

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :business_id,
      :product_id,
      :minimum_order_quantity,
      :wholesale_price,
      :available_quantity,
      :status
    ]
  end
end
