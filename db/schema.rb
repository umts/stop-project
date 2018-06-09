# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180608191700) do

  create_table "bus_stop_fields", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "bus_stop_id", null: false
    t.bigint "field_id", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bus_stops", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", default: "", null: false
    t.string "hastus_id", null: false
    t.string "accessible"
    t.string "bench"
    t.string "curb_cut"
    t.string "lighting"
    t.string "mounting"
    t.string "mounting_direction"
    t.string "schedule_holder"
    t.string "shelter"
    t.string "sidewalk"
    t.string "sign"
    t.string "trash"
    t.boolean "bolt_on_base"
    t.boolean "bus_pull_out_exists"
    t.boolean "extend_pole"
    t.boolean "has_power"
    t.boolean "new_anchor"
    t.boolean "new_pole"
    t.boolean "solar_lighting"
    t.boolean "straighten_pole"
    t.boolean "system_map_exists"
    t.integer "mounting_clearance_after"
    t.integer "mounting_clearance_before"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "completed"
    t.datetime "completed_at"
    t.string "sign_type"
    t.string "shelter_condition"
    t.string "shelter_pad_condition"
    t.string "shelter_pad_material"
    t.string "shelter_type"
  end

  create_table "bus_stops_routes", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "bus_stop_id", null: false
    t.integer "route_id", null: false
  end

  create_table "fields", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "category"
    t.text "description"
    t.integer "rank"
    t.string "field_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "choices"
  end

  create_table "routes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "item_type", limit: 191, null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
