class RenameTitleAndDescriptionInVideos < ActiveRecord::Migration[7.0]
  def up
    if column_exists?(:videos, :title)
      rename_column :videos, :title, :menu_name
    end

    if column_exists?(:videos, :description)
      rename_column :videos, :description, :price
    end
    
    Video.where(price: '').update_all(price: nil) if column_exists?(:videos, :price)
    change_column :videos, :price, :integer if column_exists?(:videos, :price)
  end

  def down
    if column_exists?(:videos, :menu_name)
      rename_column :videos, :menu_name, :title
    end

    if column_exists?(:videos, :price)
      change_column :videos, :price, :string
      rename_column :videos, :price, :description
    end
  end
end
