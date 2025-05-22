class CartsController < ApplicationController
  def show
    @items = (@cart.present? && @cart.items.present?) ? @cart.items : []
  end
end
