Rails.application.routes.draw do
  get '/search' => "products#search"
  get '/current_cart' => "carts#show", :as => 'current_cart'
  post '/order' => "carts#order"
  post '/add_to_cart' => 'items#create', :as => 'add_to_cart'
  post '/update_cart_item' => 'items#update', :as => 'update_cart_item'
  post '/delete_cart_item' => 'items#destroy', :as => 'delete_cart_item'

  resources :carts, only: [:show]
  resources :products
  resources :items, only: [:create, :update, :destroy]
		
  root 'products#index'
end
