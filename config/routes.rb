Rails.application.routes.draw do
  resources :marketplace_listings do
    collection do
      get :my_marketplace_listings
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :categories
  resources :products
  resources :request_for_quotations do
    collection do
      get :my_rfqs
    end
  end
  resources :rfq_items
  resources :quotations do
    collection do
      get :my_quotations
    end
  end
  resources :quotation_items
  resources :orders do
    collection do
      get :my_orders
      post :create_with_items
    end
  end
  resources :order_items

  resources :wholesaler_products do
    collection do
      post :find_best_wholesalers
    end
  end
  resources :businesses do
    collection do
      get :my_business
    end
  end
  resources :delivery_order_items
  resources :delivery_orders do
    member do
      patch :cancel
      put :assign_driver
      put :start_delivery
      put :complete_delivery
    end
    collection do
      get :my_deliveries
      get :assigned_deliveries
      get :daily_aggregates
      get :monthly_aggregates
    end
  end

  resources :vehicles

  resources :business_documents do
    collection do
      get :my_business_documents
      get "by_user/:user_id", to: "business_documents#get_by_user", as: :by_user
    end
  end
end
