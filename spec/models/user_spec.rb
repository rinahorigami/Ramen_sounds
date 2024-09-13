require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'バリデーションテスト' do
    it '有効なユーザーを作成できる' do
      expect(user).to be_valid
    end

    it 'メールアドレスがないと無効である' do
      user.email = ''
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("この項目は必須です。")
    end

    it 'パスワードが3文字未満の場合は無効である' do
      user.password = '12'
      user.password_confirmation = '12'
      expect(user).to_not be_valid
      expect(user.errors[:password]).to include("パスワードは3文字以上で入力してください。")
    end

    it 'メールアドレスが一意でなければ無効である' do
      create(:user, email: 'duplicate@example.com')
      user.email = 'duplicate@example.com'
      expect(user).to_not be_valid
      expect(user.errors[:email]).to include("このメールアドレスはすでに存在します。")
    end
  end

  describe 'アバターアップロード' do
    it 'アバター画像がアップロードされている' do
      expect(user.avatar).to be_present
    end
  end

  describe 'ユーザー削除時のアバター削除' do
    it 'ユーザー削除時にS3からアバターを削除する' do
      user.save
      expect(user.avatar).to be_present

      expect(user.avatar).to receive(:remove!)
      user.destroy
    end
  end
end