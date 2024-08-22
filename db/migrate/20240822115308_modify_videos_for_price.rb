class ModifyVideosForPrice < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :price, :integer unless column_exists?(:videos, :price)
  end
end
