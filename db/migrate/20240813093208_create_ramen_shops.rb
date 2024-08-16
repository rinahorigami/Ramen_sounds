class CreateRamenShops < ActiveRecord::Migration[7.0]
  def change
    create_table :ramen_shops do |t|
      t.string :place_id, null: false
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :phone_number
      t.text :opening_hours

      t.timestamps
    end
  end
end
