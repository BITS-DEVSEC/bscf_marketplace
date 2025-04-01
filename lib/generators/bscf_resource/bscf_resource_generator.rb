class BscfResourceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create_controller
    template "controller.erb", "app/controllers/#{plural_name}_controller.rb"
  end

  def create_serializer
    template "serializer.erb", "app/serializers/#{singular_name}_serializer.rb"
  end

  def add_routes
    route "resources :#{plural_name}"
  end

  def create_test
    template "controller_spec.erb", "spec/requests/#{plural_name}_spec.rb"
  end
end
