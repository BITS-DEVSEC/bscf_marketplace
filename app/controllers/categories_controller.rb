class CategoriesController < ApplicationController
  include Common

  def includes
    [ :parent ]
  end

  private

  def model_params
    params.require(:payload).permit(:name, :description, :parent_id)
  end
end
