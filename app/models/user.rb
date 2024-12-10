class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :videos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_videos, through: :likes, source: :video
  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  mount_uploader :avatar, AvatarUploader

  enum role: { general: 0, admin: 1 }
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  before_destroy :remove_avatar_from_s3

  def liked?(video)
    liked_videos.include?(video)
  end

  private

  def remove_avatar_from_s3
    avatar.remove!
  end
end
