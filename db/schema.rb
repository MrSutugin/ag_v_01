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

ActiveRecord::Schema[7.0].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "account_email_auth_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "account_login_change_keys", force: :cascade do |t|
    t.string "key", null: false
    t.string "login", null: false
    t.datetime "deadline", null: false
  end

  create_table "account_password_reset_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "account_remember_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
  end

  create_table "account_verification_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "status", default: 1, null: false
    t.citext "email", null: false
    t.string "password_hash"
    t.index ["email"], name: "index_accounts_on_email", unique: true, where: "(status = ANY (ARRAY[1, 2]))"
  end

  create_table "locations", force: :cascade do |t|
    t.string "country_code"
    t.string "country_name"
    t.string "country_name_en"
    t.decimal "country_geo_lat", precision: 15, scale: 10
    t.decimal "country_geo_lon", precision: 15, scale: 10
    t.string "country_region_full_address"
    t.string "country_region_name"
    t.string "country_region_fias_type"
    t.string "country_region_okato"
    t.string "country_region_oktmo"
    t.decimal "country_region_geo_lat", precision: 15, scale: 10
    t.decimal "country_region_geo_lon", precision: 15, scale: 10
    t.string "country_region_peoples"
    t.string "country_region_timezone"
    t.string "country_region_wiki"
    t.string "country_region_locality_full_address"
    t.string "country_region_locality_name"
    t.string "country_region_locality_fias"
    t.string "country_region_locality_fias_type"
    t.string "country_region_locality_type"
    t.string "country_region_locality_okato"
    t.string "country_region_locality_oktmo"
    t.decimal "country_region_locality_geo_lat", precision: 15, scale: 10
    t.decimal "country_region_locality_geo_lon", precision: 15, scale: 10
    t.string "country_region_locality_peoples"
    t.string "country_region_locality_timezone"
    t.string "country_region_locality_wiki"
    t.string "located_type", null: false
    t.bigint "located_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_locations_on_account_id"
    t.index ["located_type", "located_id"], name: "index_locations_on_located"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "username", null: false
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.integer "gender", default: 0
    t.text "bio"
    t.date "birthdate"
    t.string "phone_number"
    t.string "phone_verification_code"
    t.boolean "phone_is_verified", default: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_profiles_on_account_id"
  end

  add_foreign_key "account_email_auth_keys", "accounts", column: "id"
  add_foreign_key "account_login_change_keys", "accounts", column: "id"
  add_foreign_key "account_password_reset_keys", "accounts", column: "id"
  add_foreign_key "account_remember_keys", "accounts", column: "id"
  add_foreign_key "account_verification_keys", "accounts", column: "id"
  add_foreign_key "locations", "accounts"
  add_foreign_key "profiles", "accounts"
end
