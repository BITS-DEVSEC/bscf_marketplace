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

      item_errors = []
      
      items_params.each do |item_params|
        item = @record.send(items_association).build(item_params)
        unless item.save
          item_errors << item.errors.full_messages
        end
      end
      
      if item_errors.any?
        render json: { success: false, errors: item_errors.flatten }, status: :unprocessable_entity
        return false
      end

      render json: {
        success: true,
        id: @record.id,
        data: @record
      }, status: :created
    end
  end

  private

  def model_class
    "Bscf::Core::#{controller_name.classify}".constantize
  end

  def items_association
    if controller_name == "request_for_quotations"
      "rfq_items"
    else
      "#{controller_name.singularize}_items"
    end
  end

  def main_params
    params.require(controller_name.singularize).permit(permitted_params)
  end

  def items_params
    simple_param_name = "#{controller_name.singularize}_items"
    namespaced_param_name = "Bscf::Core::#{controller_name.singularize}_items"
    abbreviated_param_name = "rfq_items" if controller_name == "request_for_quotations"
    
    if params.has_key?(simple_param_name)
      params.require(simple_param_name).map do |item|
        item.permit(permitted_item_params)
      end
    elsif params.has_key?(namespaced_param_name)
      params.require(namespaced_param_name).map do |item|
        item.permit(permitted_item_params)
      end
    elsif abbreviated_param_name && params.has_key?(abbreviated_param_name)
      params.require(abbreviated_param_name).map do |item|
        item.permit(permitted_item_params)
      end
    else
      expected_params = [simple_param_name, namespaced_param_name]
      expected_params << abbreviated_param_name if abbreviated_param_name
      
      raise ActionController::ParameterMissing.new(
        "param is missing or the value is empty: one of #{expected_params.join(', ')}"
      )
    end
  end

  def permitted_params
    raise NotImplementedError, "#{self.class} must implement permitted_params"
  end

  def permitted_item_params
    raise NotImplementedError, "#{self.class} must implement permitted_item_params"
  end
end