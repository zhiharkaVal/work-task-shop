class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_cart

  before_action -> { current_cart }

  def current_cart
    # TODO: replace cart with current user
    if session[:cart_id].present?
      @cart ||= Cart.find_by_id(session[:cart_id])
      return @cart
    else
      @cart = Cart.create
      session[:cart_id] = @cart.id
      return @cart
    end
  end
end