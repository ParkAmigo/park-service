class ParkingLotVehicleDetail < ApplicationRecord
  belongs_to :parking_lot
  belongs_to :vehicle_type

  validates :vehicle_type_id,
            uniqueness: { scope: :parking_lot_id,
                          message: I18n.t('activerecord.errors.messages.must_be_unique_within_this_parking_lot') }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :base_fare, :minimum_duration, :additional_charge_per_hour, presence: true
end
