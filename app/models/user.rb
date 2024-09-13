class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :videos, dependent: :destroy

  mount_uploader :avatar, AvatarUploader
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  before_destroy :remove_avatar_from_s3

  private

  def remove_avatar_from_s3
    avatar.remove!
  end
end
