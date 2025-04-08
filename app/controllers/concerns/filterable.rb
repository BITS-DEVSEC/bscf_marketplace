module Filterable
  extend ActiveSupport::Concern

  def filter_records(records)
    @q = records.ransack(params[:q])
    @q.result(distinct: true)
  end
end
