module CreatableWithItems
  extend ActiveSupport::Concern

  def create_with_items
    ActiveRecord::Base.transaction do
      @record = model_class.new(main_params)
      @record.user = current_user if @record.respond_to?(:user=)
      @record.ordered_by = current_user if @record.respond_to?(:ordered_by=)

      unless @record.save
        render json: { success: false, errors: @record.errors.full_messages }, status: :unprocessable_entity
        return
      end

      items_params.each do |item_params|
        item = @record.send(items_association).build(item_params)
        unless item.save
          raise ActiveRecord::Rollback
          render json: { success: false, errors: item.errors.full_messages }, status: :unprocessable_entity
          return
        end
      end

      render json: {
        success: true,
        record: @record,
        items: @record.send(items_association)
      }, status: :created
    end
  end

  private

  def model_class
    controller_name.classify.constantize
  end

  def items_association
    "#{controller_name.singularize}_items"
  end

  def main_params
    params.require(controller_name.singularize).permit(permitted_params)
  end

  def items_params
    params.require("#{controller_name.singularize}_items").map do |item|
      item.permit(permitted_item_params)
    end
  end

  def permitted_params
    raise NotImplementedError, "#{self.class} must implement permitted_params"
  end

  def permitted_item_params
    raise NotImplementedError, "#{self.class} must implement permitted_item_params"
  end
end
