class VehiclesController < ApplicationController
  include Common

  def includes
    [ :driver ]
  end

  private

  def model_params
    params.require(:payload).permit(
      :driver_id,
      :plate_number,
      :vehicle_type,
      :brand,
      :model,
      :year,
      :color
    )
  end
end
