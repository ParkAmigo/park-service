FactoryBot.define do
  factory :parking_lot do
    sequence(:code) { |n| "PL#{n}" }
    owner factory: %i[user]
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    verification_status { 0 }

    after(:build) do |parking_lot|
      parking_lot.address ||= build(:address, parking_lot: parking_lot)
      parking_lot.parking_lot_vehicle_details << build_list(:parking_lot_vehicle_detail, 1, parking_lot: parking_lot)
    end
  end
end
