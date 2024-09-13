require 'webmock/rspec'

RSpec.describe 'RamenShops 検索フォーム', type: :system do
  let(:user) { create(:user, password: 'password') }

  before do
    WebMock.enable!

    # Google Places APIのモック（場所検索）
    stub_request(:get, "https://maps.googleapis.com/maps/api/place/nearbysearch/json")
      .with(query: hash_including({
        "key" => ENV['GOOGLE_PLACES_API_KEY'],
        "keyword" => "渋谷 ラーメン",
        "language" => "ja",
        "location" => "35.68950000,139.69170000",
        "radius" => "18000",
        "types" => "restaurant"
      }))
      .to_return(
        status: 200,
        body: {
          "results": [
            {
              "name": "Tokyo Ramen Shop",
              "place_id": "tokyo_place_id",
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

  it '場所タブを選択して場所検索できる' do
    visit ramen_shops_path
    find('#tab-location').click
    fill_in 'search-keyword', with: '渋谷'
    click_button '検索'

    puts "場所検索 API レスポンス: #{page.body}"

    sleep 5
    expect(page).to have_content('一蘭 渋谷店')
  end

  after do
    WebMock.disable!
  end
  
end