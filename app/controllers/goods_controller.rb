class GoodsController < ApplicationController
	
	# Displays products in catalog with pagination 4 products/page
	# If user made a query by the beginning of the product name, also displays products meeting the query.
	# Within the search (or in case user wants just to sort products) the products could be sorted in ascending order either by name or by price
	# User also could select product within particular price range
	def index
			@goods = Good.paginate(:page => params[:page], :per_page => 4)
			@item = current_cart.items.new
			if (params[:sorted_name].to_s == "true") 
				@goods = Good.order("name ASC").paginate(:page => params[:page], :per_page => 4)
				filtering_params(params).each do |key, value|
					@goods = @goods.public_send(key, value) if value.present?
			end
			elsif (params[:sorted_price].to_s == "true")
				@goods = Good.reorder("price ASC").paginate(:page => params[:page], :per_page => 4)
				filtering_params(params).each do |key, value|
					@goods = @goods.public_send(key, value) if value.present?
			end
			elsif (params[:group_max].to_i < Good.all.maximum(:price) && params[:group_min].to_i > Good.all.minimum(:price))
				@goods = Good.all.group(:price).having("price < ?", params[:group_max])
			end
			else 
				filtering_params(params).each do |key, value|
					@goods = @goods.public_send(key, value) if value.present?
			end
	end
	
	#Adds new good(product) into catalog
	def new
		@good = Good.new
	end
	
	# Shows the good with a specified id from the list
	def show
		@good = Good.find(params[:id])
	end
	
	#Allows to edit the good(product) in  the catalog
	def edit
		@good = Good.find(params[:id])		
	end
	
	#Adds product to database
	def create
		@good = Good.new(good_params)
 
		if @good.save
			redirect_to @good
		else 
			render 'new'
		end
	end
	
	# If any changes have been made in the edit form of the product, they will be saved to the database
	def update
		@good = Good.find(params[:id])
 
		if @good.update(good_params)
			redirect_to @good
		else
			render 'edit'
		end
	end
		
	#Removes the good(product) from the catalog
	def destroy
		@good = Good.find(params[:id])
		@good.destroy
 
		redirect_to goods_path
	end
	
	# Reloads the product catalof which would meet the desired query
	# The query could have min&max price range & beginning of product's name
	# In addition user could sort queried products by name or by price
	def search
		query= params[:starts_with].to_s
		searchByName = params[:sorted_name].to_s;
		searchByPrice = params[:sorted_price].to_s;
		minPrice = params[:price_min];
		maxPrice = params[:price_max];
		if (query.to_s != "")
		redirect_to goods_path(@goods, starts_with: query, sorted_name: searchByName, sorted_price: searchByPrice, price_min: minPrice, price_max: maxPrice)
		else
			redirect_to goods_path(@goods, sorted_name: searchByName, sorted_price: searchByPrice, price_min: minPrice, price_max: maxPrice)
		end
	end
	
	private
		def good_params
			params.require(:good).permit(:name, :stock, :price)
		end
		
		def filtering_params(params)
		  params.slice( :starts_with, :price_min, :price_max)
		end
end
