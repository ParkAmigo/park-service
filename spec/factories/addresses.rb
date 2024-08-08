FactoryBot.define do
  factory :address do
    address_line_first { Faker::Address.street_address }
    address_line_second { Faker::Address.secondary_address }
    pin_code { Faker::Number.number(digits: 6) }

    parking_lot
  end
end
