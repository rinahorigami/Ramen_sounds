class RenameTitleAndDescriptionInVideos < ActiveRecord::Migration[7.0]
  def change
    if column_exists?(:videos, :title)
      rename_column :videos, :title, :menu_name
    end
  
    if column_exists?(:videos, :description)
      rename_column :videos, :description, :price
    end
    
    Video.where(price: '').update_all(price: nil) if column_exists?(:videos, :price)

    if column_exists?(:videos, :price)
      change_column :videos, :price, 'integer USING CAST(price AS integer)'
    end
  end
end
