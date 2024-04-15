class Good < ApplicationRecord
	has_many :items

	validates :name, presence: true,
                     uniqueness: true
	validates :price, numericality: { greater_than: 0 }
	validates :stock, numericality: { only_integer: true, greater_than: 0 }
	
	scope :starts_with, -> (name) { where("name like ?", "#{name}%")}
	scope :price_min, -> (min) { where('price > ?', min) }
	scope :price_max, -> (max) { where('price < ?', max) }
end
