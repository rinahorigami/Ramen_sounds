FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { Faker::Internet.unique.email }
    password { "password" }
    password_confirmation { "password" }
    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/avatar.png'), 'image/png') }
  end
end