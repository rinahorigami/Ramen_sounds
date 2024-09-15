FactoryBot.define do
  factory :comment do
    content { "MyText" }
    user { nil }
    video { nil }
  end
end
