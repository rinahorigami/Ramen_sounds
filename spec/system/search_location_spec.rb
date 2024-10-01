require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'RamenShops 検索フォーム', type: :system do
  let(:user) { create(:user, password: 'password') }
  let!(:ramen_shop) { create(:ramen_shop, name: 'Test Ramen Shop') }

  before do
    WebMock.enable!

    # Google Places APIのモック（場所検索）
    stub_request(:get, /maps.googleapis.com/)
      .with(query: hash_including({ "key" => ENV['GOOGLE_PLACES_API_KEY'] }))
      .to_return(
        status: 200,
        body: {
          "results": [
            {
              "name": "Test Ramen Shop",
              "place_id": "test_place_id",
              "formatted_address": "Tokyo, Japan"
            }
          ],
          "status": "OK"
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    # テストユーザーのログイン処理
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content('ログインしました。')
  end

  it '場所検索で店舗を検索できる' do
    visit ramen_shops_path
    find('#tab-location').click
    fill_in 'search-keyword', with: 'Tokyo'
    click_button '検索'

    expect(page).to have_content('Test Ramen Shop')
  end

  after do
    WebMock.disable!
  end
end