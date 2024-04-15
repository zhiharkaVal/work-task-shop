class Item < ApplicationRecord
	belongs_to :good
	belongs_to :cart
  
	validates :amount, presence: true, 
						numericality: { only_integer: true, greater_than: 0 }
	validate :good_present
	validate :cart_present

	private
		def good_present
			if good.nil?
			  errors.add(:good, "is not valid or is not active.")
			end
		end
		
		def compare_stock_amount
			if good.stock < amount
				errors.add(:cart, "There are not enough products!")
			end
		end

		def cart_present
			if cart.nil?
				errors.add(:cart, "is not a valid cart.")
			end
		end
end
