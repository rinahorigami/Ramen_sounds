class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.references :video, null: false, foreign_key: true, type: :bigint

      t.timestamps
    end
  end
end
