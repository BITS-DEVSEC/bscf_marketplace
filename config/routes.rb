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
end
