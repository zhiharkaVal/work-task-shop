class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :stock
      t.decimal :price

      t.timestamps
    end
  end
end
