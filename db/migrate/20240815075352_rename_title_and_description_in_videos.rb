class RenameTitleAndDescriptionInVideos < ActiveRecord::Migration[7.0]
  def change
    # 既存のカラムをリネーム（存在を確認してからリネーム）
    if column_exists?(:videos, :title)
      rename_column :videos, :title, :menu_name
    end

    if column_exists?(:videos, :description)
      rename_column :videos, :description, :price
    end

    # priceカラムの空文字列をnilに変換
    Video.where(price: '').update_all(price: nil) if column_exists?(:videos, :price)

    # priceカラムの型を変更
    if column_exists?(:videos, :price)
      change_column :videos, :price, :integer
    end
  end
end
