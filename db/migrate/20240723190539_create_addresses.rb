class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.references :parking_lot, foreign_key: true, null: false
      t.text :address_line_first, null: false
      t.text :address_line_second, null: false
      t.text :pin_code, null: false
      t.timestamps
    end
  end
end
