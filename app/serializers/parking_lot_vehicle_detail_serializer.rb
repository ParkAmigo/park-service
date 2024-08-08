class ParkingLotVehicleDetailSerializer < ActiveModel::Serializer
  attributes :id, :capacity, :base_fare, :minimum_duration, :additional_charge_per_hour
  belongs_to :vehicle_type

  attribute :vehicle_type do
    object.vehicle_type&.name
  end
end
