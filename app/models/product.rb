class Product < ApplicationRecord
  DEFAULT_MIN_PRODUCT_PRICE = 0
  DEFAULT_MAX_PRODUCT_PRICE = 1000

  validates :name, presence: true, uniqueness: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  self.per_page = 10

  def self.search_by(min_price, max_price, name, sort_by)
    search_result = Product.where('price > ? AND price < ? AND name like ?', min_price - 1, max_price + 1, "#{name}%")
    sort_by.present? ? search_result.order(sort_by) : search_result
  end

  def update_stock(amount_to_be_purchased)
    # TODO: add validation
    stock =- amount_to_be_purchased
    save!
  end

  def restock!(restock_amount)
    # TODO: add validation
    stock =+ restock_amount
    save!
  end
end
