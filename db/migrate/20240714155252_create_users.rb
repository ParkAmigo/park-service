class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :mobile_number, null: false, index: true
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end
  end
end