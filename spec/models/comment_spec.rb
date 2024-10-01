require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:video) { create(:video) }
  let(:comment) { build(:comment, user: user, video: video) }

  describe 'バリデーション' do
    it '有効なコメントが作成できる' do
      expect(comment).to be_valid
    end

    it '空の場合は無効である' do
      comment.content = nil
      comment.valid?
      expect(comment.errors[:content]).to include('この項目は必須です。')
    end
  end
  
  describe 'アソシエーション' do
    it 'ユーザーと関連づけられている' do
      expect(comment.user).to eq(user)
    end
 
    it '動画と関連づけられている' do
      expect(comment.video).to eq(video)
    end
  end
end
