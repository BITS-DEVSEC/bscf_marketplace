Rails.application.config.to_prepare do
  # Extend all models from bscf-core gem with Ransackable concern
  if defined?(Bscf::Core)
    Bscf::Core.constants.each do |const|
      klass = "Bscf::Core::#{const}".constantize
      if klass.is_a?(Class) && klass < ActiveRecord::Base
        klass.include Ransackable
      end
    rescue
      # Skip if not a valid ActiveRecord model
    end
  end
end
