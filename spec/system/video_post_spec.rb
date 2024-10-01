require 'rails_helper'
require 'webmock/rspec'

RSpec.describe '動画投稿機能', type: :system do
  let(:user) { create(:user, password: 'password') }
  let!(:ramen_shop) { create(:ramen_shop, name: 'Test Ramen Shop', place_id: 'test_place_id') }

  before do
    WebMock.enable!

    # Google Places APIのモック
    stub_request(:get, /maps.googleapis.com\/maps\/api\/place\/details\/json/)
      .with(query: hash_including({ "place_id" => "test_place_id" }))
      .to_return(
        status: 200,
        body: {
          "result": {
            "place_id": "test_place_id",
            "name": "Test Ramen Shop",
            "formatted_address": "Tokyo, Japan",
            "formatted_phone_number": "123-456-7890",
            "geometry": {
              "location": {
                "lat": 35.6895,
                "lng": 139.6917
              }
            },
            "opening_hours": {
              "weekday_text": [
                "Monday: 9:00 AM – 10:00 PM",
                "Tuesday: 9:00 AM – 10:00 PM"
              ]
            }
          },
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

  it '検索フォームでラーメン店を選択し、動画を店舗と関連づけて投稿できる' do
    visit ramen_shops_path(from_video_form: 'new')
    
    find('#tab-name').click
    fill_in 'search-keyword', with: 'Test Ramen Shop'
    click_button '検索'
    
    # 検索結果のリンクをパラメータ付きで探してクリックする
    find("a[href*='test_place_id'][href*='from_video_form=new']").click
  
    click_link 'この店舗を選択'
  
    expect(page).to have_content('動画投稿')
    fill_in 'メニュー名', with: '醤油ラーメン'
    fill_in '金額', with: 800
    fill_in 'コメント', with: 'とても美味しいラーメンでした！'
    fill_in 'video_tag_list', with: 'ラーメン'
    attach_file '動画をアップロード', Rails.root.join('spec/fixtures/sample_video.mp4')
    
    click_button '投稿'
    
    expect(page).to have_content('動画が投稿されました。')
    expect(page).to have_content('ラーメン')
    expect(page).to have_content('800')
    expect(page).to have_content('Test Ramen Shop')
  end

  after do
    WebMock.disable!
  end
end


