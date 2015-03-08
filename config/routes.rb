Rails.application.routes.draw do

  ###########
  # Work Schedule Groups  
  ###########

  resources :work_schedule_groups do 
    collection do 
      put 'batch_destroy'
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  ###########
  # Simlations 
  ###########

  resources :simulations do 
    collection do 
      post 'movement'
      post 'speeding'
      post 'outside_work_hours'
      post 'long_pause'
      post 'long_driving'
      post 'enter_area'
      post 'left_area'
    end
  end

  # just a dummy path to test exception notifier 
  get 'test_exception_notifier' => 'application#test_exception_notifier'

  ###########
  # Subscription
  ###########

  resources :subscriptions do 
    member do 
      get 'generate'
    end
  end

  ###########
  # Alarm Notifications   
  ###########

  resources :alarm_notifications, :path => 'alerts' do 
    member do 
      get 'archive'
    end
    collection do 
      put 'batch_archive'
    end
  end

  resources :plans
  resources :plan_types
  resources :notifications
  resources :vertices

  resources :regions do 
    collection do 
      put 'batch_destroy'
    end
  end

  resources :features

  resources :conversations do 
    member do 
      post 'reply'
    end
    collection do 
      put 'mark_as_action'
    end
  end

  resources :work_schedules do 
    collection do 
      put 'batch_destroy'
    end
  end

  resources :parameters

  resources :alarms do 
    collection do 
      get 'region'
      put 'batch_destroy'
    end
  end

  resources :rules do 
    member do 
      get 'rule_params_list'
    end
    collection do 
      get 'regions'
      get 'work_schedules'
    end

  end
  resources :work_hours 

  resources :simcards do 
    collection do 
      put 'batch_destroy'
    end
  end
  
  resources :teleproviders do 
    collection do 
      put 'batch_destroy'
    end
  end
  resources :device_types do 
    collection do 
      put 'batch_destroy'
    end
  end
  resources :device_models do 
    collection do 
      put 'batch_destroy'
    end
  end
  resources :device_manufacturers do 
    collection do 
      put 'batch_destroy'
    end
  end
  resources :groups do 
    member do 
      get 'live'
    end
    collection do 
      put 'batch_destroy'
    end
  end

  resources :cars do 
    collection do 
      get 'live'
      put 'batch_destroy'
    end

    member do
      get 'details' 
    end

  end

  resources :car_types do 
    collection do 
      put 'batch_destroy'
    end
  end

  resources :car_models do 
    collection do 
      put 'batch_destroy'
    end
  end

  resources :car_manufacturers do 
    collection do 
      put 'batch_destroy'
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  resources :devices do 
    collection do 
      get 'live_map'
      put 'batch_destroy'
    end
  end

  resources :home do 
    collection do 
      get 'test'
    end
  end 

  resources :companies

  devise_for :users, controllers: { registrations: "registrations", :invitations => 'invitations' }
  
  resources :users do 
    member do 
      get 'conversations'
      get 'notifications'
    end
    collection do 
      put 'batch_destroy'
    end
  end

  namespace :api do
    resources :simcards
    resources :teleproviders
    resources :device_types
    resources :device_models
    resources :device_manufacturers
    resources :groups
    resources :cars
    resources :car_types
    resources :car_models
    resources :car_manufacturers
    resources :companies
    resources :users
    resources :devices
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
