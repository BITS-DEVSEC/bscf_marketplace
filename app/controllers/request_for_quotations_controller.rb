class RequestForQuotationsController < ApplicationController
  include Common
  include CreatableWithItems
  before_action :is_authenticated

  private

  def permitted_params
    [:status, :notes]
  end

  def permitted_item_params
    [:product_id, :quantity, :notes]
  end
end
