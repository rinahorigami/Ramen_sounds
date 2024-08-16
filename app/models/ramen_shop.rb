class RamenShop < ApplicationRecord
  has_many :videos
  validates :name, :address, :place_id, presence: true
end
