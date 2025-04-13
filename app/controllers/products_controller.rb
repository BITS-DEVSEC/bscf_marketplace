class ProductsController < ApplicationController
  include Common

  private

  def model_params
    params.require(:payload).permit(permitted_params)
  end

  def permitted_params
    [
      :name,
      :description,
      :category_id,
      :base_price,
      :thumbnail,
      { images: [] }
    ]
  end
end
