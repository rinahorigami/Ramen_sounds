FactoryBot.define do
  factory :comment do
    content { "MyText" }
    association :user
    association :video
  end
end
