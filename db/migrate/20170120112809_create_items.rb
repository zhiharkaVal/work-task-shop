class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.belongs_to :cart
      t.belongs_to :product
      t.integer :amount

      t.timestamps
    end
  end
end
