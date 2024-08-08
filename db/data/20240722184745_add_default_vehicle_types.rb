# frozen_string_literal: true

class AddDefaultVehicleTypes < ActiveRecord::Migration[7.0]
  def up
    VehicleType.create!(name: 'Two Wheeler')
    VehicleType.create!(name: 'Three Wheeler')
    VehicleType.create!(name: 'Four Wheeler')
    VehicleType.create!(name: 'Traveller')
    VehicleType.create!(name: 'Bus')
    VehicleType.create!(name: 'Truck')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
