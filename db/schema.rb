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

ActiveRecord::Schema[7.0].define(version: 2024_07_16_171534) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "otp_requests", force: :cascade do |t|
    t.string "mobile_number", null: false
    t.string "otp", null: false
    t.datetime "expire_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mobile_number", "otp"], name: "index_otp_requests_on_mobile_number_and_otp"
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

end
