require 'rails_helper'

RSpec.describe 'RamenShops 検索フォーム', type: :system do
  let(:user) { create(:user, password: 'password') }
  let!(:ramen_shop) { create(:ramen_shop, name: 'Test Ramen Shop') }
  let(:video) { create(:video, user: user, ramen_shop: ramen_shop) }

  before do
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content('ログインしました。')
  end

  it '店舗名タブを選択して店舗名検索できる' do
    visit ramen_shops_path
    find('#tab-name').click
    fill_in 'search-keyword', with: 'Test Ramen Shop'
    click_button '検索'

    expect(page).to have_content('Test Ramen Shop')
  end

  it 'タグタブを選択してタグ検索ができる' do
    allow(Video).to receive(:by_tag).with('醤油ラーメン').and_return([video])

    visit ramen_shops_path
    find('#tab-tag').click
    fill_in 'search-keyword', with: '醤油ラーメン'
    click_button '検索'

    expect(page).to have_content('醤油ラーメン')
  end
end
