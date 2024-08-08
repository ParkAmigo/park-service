class AddUniqueIndexToParkingLotVehicleDetails < ActiveRecord::Migration[7.0]
  def change
    add_index :parking_lot_vehicle_details, [:vehicle_type_id, :parking_lot_id],
              unique: true, name: 'index_PLVD_on_vehicle_type_and_parking_lot'
  end
end
