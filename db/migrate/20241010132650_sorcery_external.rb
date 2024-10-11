class SorceryExternal < ActiveRecord::Migration[7.0]
  def change
    create_table :authentications do |t|
      t.references :user, null: false, foreign_key: true  # 外部キー制約を追加
      t.string :provider, null: false
      t.string :uid, null: false

      t.timestamps
    end

    # providerとuidの組み合わせに一意性を持たせる
    add_index :authentications, [:provider, :uid], unique: true
  end
end
