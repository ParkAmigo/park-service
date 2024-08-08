class CreateParkingLotVehicleDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :parking_lot_vehicle_details do |t|
      t.references :parking_lot, foreign_key: true, null: false
      t.references :vehicle_type, foreign_key: true, null: false
      t.integer :capacity, null: false
      t.float :base_fare, null: false
      t.integer :minimum_duration, null: false
      t.float :additional_charge_per_hour, null: false

      t.timestamps
    end
  end
end
