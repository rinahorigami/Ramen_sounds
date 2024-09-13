require 'rails_helper'

RSpec.describe Video, type: :model do
  let(:user) { create(:user) }
  let(:ramen_shop) { create(:ramen_shop) }
  let(:video) { create(:video, user: user, ramen_shop: ramen_shop) }

  describe 'バリデーション' do
    it '有効な動画を作成できる' do
      expect(video).to be_valid
    end

    it '動画ファイルがなければ無効である' do
      video.file = nil
      video.valid?
      expect(video.errors[:file]).to include("ファイルを選択してください。")
    end
  end

  describe 'アソシエーション' do
    it 'ユーザーと関連付けられている' do
      expect(video.user).to eq(user)
    end

    it 'ラーメン店と関連付けられている' do
      expect(video.ramen_shop).to eq(ramen_shop)
    end

    it 'タグと関連付けられている' do
      tag = create(:tag)
      video.tags << tag
      expect(video.tags).to include(tag)
    end
  end

  describe 'タグ機能' do
    it 'タグリストを正しく設定できる' do
      video.tag_list = '新宿,醤油ラーメン'
      expect(video.tags.map(&:name)).to include('新宿', '醤油ラーメン')
    end
  
    it 'ハッシュタグなしのタグリストを取得できる' do
      expect(video.tag_list_without_hash.force_encoding('UTF-8')).to eq('醤油ラーメン')
    end
  end

  describe 'S3から動画ファイルを削除' do
    it '動画を削除するとS3からもファイルが削除される' do
      expect(video.file).to receive(:remove!)
      video.destroy
    end
  end
end
