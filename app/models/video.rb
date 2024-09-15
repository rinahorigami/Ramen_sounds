class Video < ApplicationRecord
  mount_uploader :file, VideoUploader
  belongs_to :user
  belongs_to :ramen_shop, optional: true 
  has_many :video_tags, dependent: :destroy
  has_many :tags, through: :video_tags
  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :by_tag, -> (tag_name) {
    joins(:tags).where('tags.name LIKE ?', "%#{tag_name}%")
  }

  validates :file, presence: true

  before_destroy :remove_file_from_s3

  def tag_list=(names)
    tag_names = names.split(',').map(&:strip)
    self.tags = tag_names.map do |name|
      Tag.find_or_create_by(name: name)
    end
  end
  
  def tag_list
    tags.map { |tag| "##{tag.name}" }.join(', ')
  end

  def tag_list_without_hash
    tags.map(&:name).join(', ')
  end

  private

  def remove_file_from_s3
    file.remove!
  end
end
