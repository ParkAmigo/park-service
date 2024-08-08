class ParkingLotSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :code, :verification_status
  has_one :address
  has_many :parking_lot_vehicle_details
end
