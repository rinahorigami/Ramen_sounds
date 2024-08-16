class AddRamenShopIdToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :ramen_shop_id, :bigint
    add_foreign_key :videos, :ramen_shops
  end
end
