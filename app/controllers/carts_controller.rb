class CartsController < ApplicationController
	
	#Shows the current cart, where current cart equals session id
	def show
		@items = current_cart.items
	end
end
