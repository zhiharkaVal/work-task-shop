Rails.application.routes.draw do

	get '/search' => "goods#index"
	post '/add_to_cart/:good_id' => 'carts#add_to_cart', :as => 'add_to_cart'
		
	resources :carts, only: [:show]
	resources :goods
	resources :items, only: [:create, :update, :destroy]
		
  root 'products#index'
end
