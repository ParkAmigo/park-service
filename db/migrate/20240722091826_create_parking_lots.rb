class CreateParkingLots < ActiveRecord::Migration[7.0]
  def change
    create_table :parking_lots do |t|
      t.string :code, null: false, index: { unique: true }
      t.integer :owner_id, null: false
      t.decimal :latitude, precision: 10, scale: 7, null: false
      t.decimal :longitude, precision: 10, scale: 7, null: false
      t.integer :verification_status, default: 0, null: false
      t.timestamps
    end
  end
end
