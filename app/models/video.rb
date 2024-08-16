class Video < ApplicationRecord
  mount_uploader :file, VideoUploader
  belongs_to :user
  belongs_to :ramen_shop

  validates :file, presence: true
end
