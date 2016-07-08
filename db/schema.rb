# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160708175130) do

  create_table "bus_stops", force: :cascade do |t|
    t.string  "name",                      limit: 255, default: "", null: false
    t.string  "hastus_id",                 limit: 255,              null: false
    t.string  "accessible",                limit: 255
    t.string  "bench",                     limit: 255
    t.string  "curb_cut",                  limit: 255
    t.string  "lighting",                  limit: 255
    t.string  "mounting",                  limit: 255
    t.string  "mounting_direction",        limit: 255
    t.string  "schedule_holder",           limit: 255
    t.string  "shelter",                   limit: 255
    t.string  "sidewalk",                  limit: 255
    t.string  "sign",                      limit: 255
    t.string  "trash",                     limit: 255
    t.boolean "bolt_on_base"
    t.boolean "bus_pull_out_exists"
    t.boolean "extend_pole"
    t.boolean "has_power"
    t.boolean "new_anchor"
    t.boolean "new_pole"
    t.boolean "solar_lighting"
    t.boolean "straighten_pole"
    t.boolean "system_map_exists"
    t.integer "mounting_clearance_after",  limit: 4
    t.integer "mounting_clearance_before", limit: 4
  end

  create_table "bus_stops_routes", id: false, force: :cascade do |t|
    t.integer "bus_stop_id", limit: 4, null: false
    t.integer "route_id",    limit: 4, null: false
  end

  create_table "routes", force: :cascade do |t|
    t.string   "number",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255, default: "",    null: false
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.boolean  "admin",                              default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 191,        null: false
    t.integer  "item_id",    limit: 4,          null: false
    t.string   "event",      limit: 255,        null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 4294967295
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
