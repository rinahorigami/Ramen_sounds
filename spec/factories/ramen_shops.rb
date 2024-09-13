FactoryBot.define do
  factory :ramen_shop do
    place_id { "some_place_id" }
    name { "Test Ramen Shop" }
    address { "Tokyo, Japan" }
    latitude { 35.6895 }
    longitude { 139.6917 }
    phone_number { "03-1234-5678" }
    opening_hours { "Monday to Friday: 9:00 AM - 10:00 PM" }
  end
end