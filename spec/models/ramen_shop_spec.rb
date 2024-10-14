require 'rails_helper'

RSpec.describe RamenShop, type: :model do
  let(:ramen_shop) { create(:ramen_shop) }
  let(:video) { create(:video, ramen_shop: ramen_shop) }

  describe 'バリデーション' do
    it '有効なラーメンショップを作成できる' do
      expect(ramen_shop).to be_valid
    end

    it '名前がないと無効である' do
      ramen_shop.name = nil
      ramen_shop.valid?
      expect(ramen_shop.errors[:name]).to include("を入力してください")
    end

    it '住所がないと無効である' do
      ramen_shop.address = nil
      ramen_shop.valid?
      expect(ramen_shop.errors[:address]).to include("を入力してください")
    end

    it 'place_idがないと無効である' do
      ramen_shop.place_id = nil
      ramen_shop.valid?
      expect(ramen_shop.errors[:place_id]).to include("を入力してください")
    end
  end

  describe 'アソシエーション' do
    it '動画と関連付けられている' do
      ramen_shop.save
      video.save
      expect(ramen_shop.videos).to include(video)
    end
  end
end
