class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :foursquare_id
      t.integer :capacity
      t.string :name
      t.text :description
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :province
      t.integer :restaurant_id
      t.string :photo
      t.integer :price_range

      t.timestamps null: false
    end
  end
end
