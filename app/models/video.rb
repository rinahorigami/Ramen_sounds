class Video < ApplicationRecord
  mount_uploader :file, VideoUploader
  belongs_to :user
  belongs_to :ramen_shop

  validates :file, presence: true

  before_destroy :remove_file_from_s3

  private

  def remove_file_from_s3
    file.remove!
  end
end
