require 'rails_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { create(:tag)}

  describe 'バリデーションテスト' do
    it '有効なタグを作成できる' do
      expect(tag).to be_valid
    end

    it 'nameがないと無効である' do
      tag.name = ''
      tag.valid?
      expect(tag).to_not be_valid
      expect(tag.errors[:name]).to include("を入力してください")
    end
  end
end