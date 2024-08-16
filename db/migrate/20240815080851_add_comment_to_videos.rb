class AddCommentToVideos < ActiveRecord::Migration[7.0]
  def change
    add_column :videos, :comment, :text
  end
end
