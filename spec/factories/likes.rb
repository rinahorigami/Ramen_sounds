FactoryBot.define do
  factory :like do
    association :user
    association :video
  end
end
