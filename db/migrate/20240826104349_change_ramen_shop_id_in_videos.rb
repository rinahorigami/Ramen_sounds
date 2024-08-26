class ChangeRamenShopIdInVideos < ActiveRecord::Migration[7.0]
  def change
    change_column_null :videos, :ramen_shop_id, true
  end
end
