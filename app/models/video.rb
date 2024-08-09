class Video < ApplicationRecord
  mount_uploader :file, VideoUploader
  belongs_to :user

  validates :file, presence: true
end
