class Cart < ApplicationRecord
  has_many :items

  def add_item(params)
    product_id = params[:product_id]
    if items.none?{ |item| item.product_id == product_id }
      items.create!(params)
    else
      items.find{ |item| item.product_id == product_id }.increase_amount(params[:amount])
    end
  rescue StandardError => e
    errors.add(:base, "Could not add item to cart: " + e.message)
  end

  def total_sum
    items.inject(0){ |sum, item| sum + (item.amount * item.product.price) }
  end
end