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

ActiveRecord::Schema.define(version: 2021_04_27_202737) do

  create_table "bus_stops", charset: "utf8", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "hastus_id", null: false
    t.string "bench"
    t.string "curb_cut"
    t.string "lighting"
    t.string "mounting"
    t.string "mounting_direction"
    t.string "schedule_holder"
    t.string "shelter"
    t.string "sidewalk_width"
    t.boolean "bolt_on_base"
    t.boolean "bus_pull_out_exists"
    t.boolean "solar_lighting"
    t.string "mounting_clearance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed"
    t.datetime "completed_at"
    t.string "sign_type"
    t.string "shelter_condition"
    t.string "shelter_pad_condition"
    t.string "shelter_pad_material"
    t.string "shelter_type"
    t.boolean "shelter_ada_compliant"
    t.string "garage_responsible"
    t.string "bike_rack"
    t.boolean "ada_landing_pad"
    t.string "real_time_information"
    t.boolean "state_road"
    t.string "need_work"
    t.string "obstructions"
    t.boolean "accessible"
    t.string "stop_sticker"
    t.string "route_stickers"
    t.integer "completed_by"
    t.string "has_power"
    t.boolean "shared_sign_post_frta"
    t.string "system_map_exists"
    t.boolean "trash"
    t.index ["hastus_id"], name: "index_bus_stops_on_hastus_id", unique: true
  end

  create_table "bus_stops_routes", id: false, charset: "utf8", force: :cascade do |t|
    t.bigint "bus_stop_id", null: false
    t.bigint "route_id", null: false
    t.integer "sequence"
    t.string "direction"
    t.index ["bus_stop_id", "route_id", "direction"], name: "index_bus_stops_routes_on_bus_stop_id_and_route_id_and_direction", unique: true
    t.index ["sequence", "route_id", "direction"], name: "index_bus_stops_routes_on_sequence_and_route_id_and_direction", unique: true
  end

  create_table "routes", charset: "utf8", force: :cascade do |t|
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["number"], name: "index_routes_on_number", unique: true
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", charset: "utf8mb4", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
