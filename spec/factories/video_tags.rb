FactoryBot.define do
  factory :video_tag do
    association :video
    association :tag
  end
end