class Item < ApplicationRecord
	has_one :product
	belongs_to :cart
  
	validates :amount, presence: true, 
						numericality: { only_integer: true, greater_than: 0 }
	validate :product_present
	validate :cart_present

	private
		def product_present
			if product.nil?
			  errors.add(:product, "is not valid or is not active.")
			end
		end
		
		def compare_stock_amount
			if product.stock < amount
				errors.add(:cart, "There are not enough products!")
			end
		end

		def cart_present
			if cart.nil?
				errors.add(:cart, "is not a valid cart.")
			end
		end
end
