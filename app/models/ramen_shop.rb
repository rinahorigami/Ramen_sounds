class RamenShop < ApplicationRecord
  has_many :videos, foreign_key: :place_id, primary_key: :place_id
  validates :name, :address, :place_id, presence: true
end
