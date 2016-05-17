Rails.application.routes.draw do

  #######################
  # Work Schedule Groups
  #######################

  resources :work_schedule_groups do
    collection do
      put 'batch_destroy'
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'


  #############
  # Simlations
  #############

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
  get 'logbook_render' => 'home#logbook_render'
  get 'one_car_render' => 'home#one_car_render'
  get 'one_car_render_pin' => 'home#one_car_render_pin'
  get 'one_car_render_directions' => 'home#one_car_render_directions'
  get 'apply_filter' => 'home#apply_filter'
  post 'set_minimum_parking_time' => "home#set_minimum_parking_time"

  get 'reports' => 'reporting#index'
  get 'reports/devices' => 'reporting#devices', as: 'reports_devices'
  get 'reports/vehicles' => 'reporting#vehicles', as: 'reports_vehicles'
  get 'reports/simcards' => 'reporting#simcards', as: 'reports_simcards'
  get 'reports/users' => 'reporting#users', as: 'reports_users'

  ###############
  # Traccar API
  ###############

  get '/trac/Data' => 'locations#get_traccar_data'

  ###############
  # Subscription
  ###############

  resources :subscriptions do
    member do
      get 'generate'
    end
  end

  ######################
  # Alarm Notifications
  ######################

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
      get 'sentbox'
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
      put 'batch_destroy'
      get 'history'
      get 'pdf'
    end

    member do
      get 'map'
      get 'positions'
      # get 'reports'
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
      get 'cars_overview'
      get 'logbook_data'
    end
  end

  get "car_statistics" => "car_statistics#get_stats", as: "car_statistics"
  get "get_car_route" => "locations#get_car_route", as: "get_car_route"

  resources :companies

  devise_for :users, controllers: { registrations: "registrations", :invitations => 'invitations' }

  devise_scope :user do
    get "/settings" => "users#show"
  end

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

  get 'manage_devices' => 'devices#manage', as: 'device_manage'
  post 'import_devices' => 'devices#import', as: 'import_devices'

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
