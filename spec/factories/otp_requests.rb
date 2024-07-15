FactoryBot.define do
  factory :otp_request do
    mobile_number { Faker::PhoneNumber.phone_number }
    otp { Faker::Number.number(digits: 6) }
    expire_at { 10.minutes.from_now }
  end
end