class Item < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  
  validates :amount, presence: true,
                    numericality: { only_integer: true, greater_than: 0 }
  validate :product_present
  validate :enough_product_in_stock, on: [:create, :update]

  def increase_amount(additional_amount)
    total_amount = self.amount + additional_amount
    self.update!(amount: total_amount)
  end

  private
  def product_present
    if product_id.nil?
      errors.add(:product, "is not valid or is not active.")
    end
  end
		
  def enough_product_in_stock
    if amount_changed? && product.present? && product.stock < amount
      errors.add(:product, "#{product.name} has only #{product.stock} item(s) left in the stock.")
    end
  end
end
