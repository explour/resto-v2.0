class CreateCuisineTypes < ActiveRecord::Migration
  def change
    create_table :cuisine_types do |t|
      t.string :name
      t.integer :cuisine_type_id

      t.timestamps null: false
    end
  end
end
