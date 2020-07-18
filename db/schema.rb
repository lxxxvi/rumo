# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_29_084417) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hosts", force: :cascade do |t|
    t.string "name", null: false
    t.string "url_identifier", null: false
    t.string "country_time_zone_identifier", default: "Europe/Zurich", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_hosts_on_email", unique: true
    t.index ["name"], name: "index_hosts_on_name", unique: true
    t.index ["reset_password_token"], name: "index_hosts_on_reset_password_token", unique: true
    t.index ["url_identifier"], name: "index_hosts_on_url_identifier", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.bigint "host_id", null: false
    t.datetime "visited_at", null: false
    t.string "uuid", null: false
    t.string "token", null: false
    t.string "name"
    t.string "contact", null: false
    t.datetime "confirmed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["host_id", "token"], name: "index_visits_on_host_id_and_token", unique: true
    t.index ["host_id"], name: "index_visits_on_host_id"
  end

  add_foreign_key "visits", "hosts"
end
