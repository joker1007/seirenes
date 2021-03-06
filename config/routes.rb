require 'sidekiq/web'

Seirenes::Application.routes.draw do
  resources :pasokaras, only: [:index, :show, :update] do
    resources :song_queues, only: [:create]
    resources :favorites, only: [:create]
    resource :encoding, only: [:show, :create]
    resources :recordings, only: [:create]
  end

  resources :song_queues, only: [:index, :show, :update, :destroy] do
    collection do
      post :random
    end
  end
  resources :playlists, only: [:index, :show, :destroy]
  resources :histories, only: [:index]
  resources :favorites, only: [:index, :destroy]
  resource :player, only: [:show], controller: "player"
  resource :party,  only: [:show], controller: "party"
  resources :recordings, only: [:index, :show, :destroy]

  # for OmniAuth
  match "/auth/:provider/callback" => "sessions#callback", via: [:get, :post]
  match "/auth/failure" => "sessions#failure", via: [:get, :post]
  match "/logout" => "sessions#destroy", via: [:get, :delete]

  mount Sidekiq::Web => '/sidekiq'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  get "/check" => ->(env) { [200, {}, ["seirenes"]] }

  # You can have the root of your site routed with "root"
  root to: 'pasokaras#index'

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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
