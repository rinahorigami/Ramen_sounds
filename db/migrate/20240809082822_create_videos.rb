class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :file
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
