require 'webmock/rspec'

RSpec.describe 'RamenShops 検索フォーム', type: :system do
  let(:user) { create(:user, password: 'password') }
  let(:ramen_shop) { create(:ramen_shop) }
  let(:video) { create(:video, user: user, ramen_shop: ramen_shop) }

  before do
    WebMock.enable!

    # Google Places APIのモック（店舗名検索）
    stub_request(:get, "https://maps.googleapis.com/maps/api/place/nearbysearch/json")
      .with(query: hash_including({
        "key" => ENV['GOOGLE_PLACES_API_KEY'],
        "keyword" => "Test Ramen Shop ラーメン",
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

  after do
    WebMock.disable!
  end
end


