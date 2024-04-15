class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :good, foreign_key: true
      t.references :cart, foreign_key: true
      t.decimal :unit_price
      t.integer :amount

      t.timestamps
    end
  end
end
