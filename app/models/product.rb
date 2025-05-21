class Product < ApplicationRecord
  DEFAULT_MIN_PRODUCT_PRICE = 0
  DEFAULT_MAX_PRODUCT_PRICE = 1000

  validates :name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  self.per_page = 5

  def self.search_by(min_price, max_price, name, sort_by)
    search_result = Product.where('price > ? AND price < ? AND name like ?', min_price, max_price, "%#{name}%")
    sort_by.present? ? search_result.order(sort_by) : search_result
  end

  def purchase!(amount)
    return if amount == 0
    if stock < amount
      errors.add(:base, "Product '#{name}' has only #{stock} left in the stock.")
      return
    elsif amount < 0
      errors.add(:base, "Purchased amount cannot be negative!")
      return
    end
    self.stock -= amount
    save!
  end

  def restock!(restock_amount)
    return if restock_amount == 0
    if restock_amount < 0
      errors.add(:base, "Restock amount cannot be negative!")
      return
    end
    self.stock += restock_amount
    save!
  end
end
