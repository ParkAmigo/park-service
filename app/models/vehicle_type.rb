class VehicleType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :parking_lot_vehicle_details, dependent: :destroy
end
