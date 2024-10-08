class AddRememberMeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :remember_me_token, :string
    add_column :users, :remember_me_token_expires_at, :datetime
    add_index :users, :remember_me_token, unique: true
  end
end
