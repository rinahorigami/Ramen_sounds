FactoryBot.define do
  factory :video do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/sample_video.mp4'), 'video/mp4') }
    menu_name { "醤油ラーメン" }
    price { 800 }
    comment { "とても美味しいラーメンでした！" }
    association :user
    association :ramen_shop

    place_id { ramen_shop.place_id }

    # tag_listを直接設定
    after(:build) do |video|
      video.tag_list = '醤油ラーメン'
    end
  end
end