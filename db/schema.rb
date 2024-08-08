# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_07_29_194748) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.bigint "parking_lot_id", null: false
    t.text "address_line_first", null: false
    t.text "address_line_second", null: false
    t.text "pin_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parking_lot_id"], name: "index_addresses_on_parking_lot_id"
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "otp_requests", force: :cascade do |t|
    t.string "mobile_number", null: false
    t.string "otp", null: false
    t.datetime "expire_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mobile_number", "otp"], name: "index_otp_requests_on_mobile_number_and_otp"
  end

  create_table "parking_lot_vehicle_details", force: :cascade do |t|
    t.bigint "parking_lot_id", null: false
    t.bigint "vehicle_type_id", null: false
    t.integer "capacity", null: false
    t.float "base_fare", null: false
    t.integer "minimum_duration", null: false
    t.float "additional_charge_per_hour", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parking_lot_id"], name: "index_parking_lot_vehicle_details_on_parking_lot_id"
    t.index ["vehicle_type_id", "parking_lot_id"], name: "index_PLVD_on_vehicle_type_and_parking_lot", unique: true
    t.index ["vehicle_type_id"], name: "index_parking_lot_vehicle_details_on_vehicle_type_id"
  end

  create_table "parking_lots", force: :cascade do |t|
    t.string "code", null: false
    t.integer "owner_id", null: false
    t.decimal "latitude", precision: 10, scale: 7, null: false
    t.decimal "longitude", precision: 10, scale: 7, null: false
    t.integer "verification_status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_parking_lots_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "mobile_number", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mobile_number"], name: "index_users_on_mobile_number"
  end

  create_table "vehicle_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_vehicle_types_on_name", unique: true
  end

  add_foreign_key "addresses", "parking_lots"
  add_foreign_key "parking_lot_vehicle_details", "parking_lots"
  add_foreign_key "parking_lot_vehicle_details", "vehicle_types"
end
