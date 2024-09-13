require 'rails_helper'

RSpec.describe VideoTag, type: :model do
  let(:video) { create(:video) }
  let(:tag) { create(:tag) }
  let(:video_tag) { build(:video_tag, video: video, tag: tag) }

  describe 'バリデーションテスト' do
    it '有効なVideoTagを作成できる' do
      expect(video_tag).to be_valid
    end

    it 'video_idがなければ無効である' do
      video_tag.video = nil
      video_tag.valid?
      expect(video_tag.errors[:video]).to include("この項目は必須です。")
    end

    it 'tag_idがなければ無効である' do
      video_tag.tag = nil
      video_tag.valid?
      expect(video_tag.errors[:tag]).to include("この項目は必須です。")
    end
  end

  describe 'アソシエーションテスト' do
    it 'Videoと関連付けられている' do
      expect(video_tag.video).to eq(video)
    end

    it 'Tagと関連付けられている' do
      expect(video_tag.tag).to eq(tag)
    end
  end
end
