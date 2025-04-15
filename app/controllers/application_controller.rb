class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_cart

  # Creates a new new cart for a session, if there is none.
  # Otherwise sets current cart as current session
  def current_cart
    session[:cart_id].present? ? Cart.find(session[:cart_id]) : Cart.new
  rescue
    # TODO
  end
end