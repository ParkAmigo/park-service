FactoryBot.define do
  factory :parking_lot_vehicle_detail do
    vehicle_type_id { VehicleType.first.id }
    capacity { Faker::Number.non_zero_digit }
    base_fare { Faker::Number.positive.round(2) }
    minimum_duration { Faker::Number.number(digits: 2) }
    additional_charge_per_hour { Faker::Number.positive.round(2) }

    parking_lot
  end
end
