class ItemsController < ApplicationController
  
	# Adds selected product to the cart.
	# Also updates product's stock value
	def create
		@cart = current_cart
		@item = @cart.items.new(item_params)
		@good = Good.find(@item.good_id)
			if	(@good.stock >= @item.amount)
				@good.stock = @good.stock - @item.amount
			else
				@item.amount = @good.stock
				@good.stock = 0
			end
		@cart.save
		@good.save
		session[:cart_id] = @cart.id
		
		redirect_to current_cart
	end

	# Updates selected item in the cart, when user presses 'Update Item' - button
	# Also updates product's stock value
	def update
		@cart = current_cart
		@item = @cart.items.find(params[:id])
		currentAmount = @item.amount
		@item.update_attributes(item_params)
		@good = Good.find(@item.good_id)
			if (@item.amount < currentAmount)
				@good.stock = @good.stock + (currentAmount - @item.amount)
			else 
				if	(@good.stock >= @item.amount)
					@good.stock = @good.stock - @item.amount
				else
				@item.amount = @good.stock
				@good.stock = 0
			end
			end
		@items = @cart.items
		@good.save
		
		redirect_to current_cart
	end

	# Removes selected item from the cart.
	# Also updates product's stock value
	def destroy
		@cart = current_cart
		@item = @cart.items.find(params[:id])
		@item.destroy
		@good = Good.find(@item.good_id)
		@good.stock = @good.stock + @item.amount
		@items = @cart.items
		@good.save
		
		redirect_to current_cart
	end
  
	private
		def item_params
			params.require(:item).permit(:amount, :good_id)
		end
end