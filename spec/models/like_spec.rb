require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) } 
  let(:video) { create(:video) }
  let(:like) { build(:like, user: user, video: video) }

  describe 'アソシエーション' do
    it 'ユーザーと関連づけられている' do
      expect(like.user).to eq(user)
    end

    it '動画と関連づけられている' do
      expect(like.video).to eq(video)
    end
  end

  describe 'バリデーション' do
    it '同じユーザーが同じ動画に重複していいねをできない' do
      create(:like, user: user, video: video)
      duplicate_like = build(:like, user: user, video: video)
      expect(duplicate_like).not_to be_valid
      expect(duplicate_like.errors[:user_id]).to include('はすでに存在します')
    end
  end
end
