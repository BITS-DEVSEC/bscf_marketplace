class ProductsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    # Add your permitted params here
    [:sku, :name, :description, :category_id, :base_price]
  end
end
