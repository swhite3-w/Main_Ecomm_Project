class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.integer :stock_quantity
      t.string :image_url
      t.boolean :is_featured
      t.boolean :is_active
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
