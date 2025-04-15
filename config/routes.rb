Rails.application.routes.draw do
  get '/search' => "products#search"
  post '/add_to_cart/:product_id' => 'carts#add_to_cart', :as => 'add_to_cart'
		
  resources :carts, only: [:show]
  resources :products
  resources :items, only: [:create, :update, :destroy]
		
  root 'products#index'
end
