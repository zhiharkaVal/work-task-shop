class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	helper_method :current_cart

	#Creates a new new cart for a session, if there is no such a cart exsist.
	#Otherwise sets current cart as current session
	def current_cart
		if !session[:cart_id].nil?
		  Cart.find(session[:cart_id])
		else
		  Cart.new
		end
	end
end