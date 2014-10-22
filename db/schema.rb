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

ActiveRecord::Schema.define(version: 20141009050727) do

  create_table "application_settings", force: true do |t|
    t.boolean "registrationEnabled", null: false
  end

  create_table "devices", force: true do |t|
    t.string  "name"
    t.string  "uniqueId"
    t.integer "latestPosition_id", limit: 8
  end

  add_index "devices", ["latestPosition_id"], name: "FK5CF8ACDD7C6208C3", using: :btree

  create_table "positions", force: true do |t|
    t.string    "address"
    t.float     "altitude",   limit: 53
    t.float     "course",     limit: 53
    t.float     "latitude",   limit: 53
    t.float     "longitude",  limit: 53
    t.string    "other"
    t.float     "power",      limit: 53
    t.float     "speed",      limit: 53
    t.datetime  "time"
    t.boolean   "valid"
    t.integer   "device_id",  limit: 8
    t.timestamp "created_at",            null: false
  end

  add_index "positions", ["device_id", "time"], name: "positionsIndex", using: :btree
  add_index "positions", ["device_id"], name: "FK65C08C6ADB0C3B8A", using: :btree

  create_table "user_settings", force: true do |t|
    t.string "speedUnit"
  end

  create_table "users", force: true do |t|
    t.boolean "admin"
    t.string  "login"
    t.string  "password"
    t.integer "userSettings_id", limit: 8
  end

  add_index "users", ["userSettings_id"], name: "FK6A68E0862018CAA", using: :btree

  create_table "users_devices", id: false, force: true do |t|
    t.integer "users_id",   limit: 8, null: false
    t.integer "devices_id", limit: 8, null: false
  end

  add_index "users_devices", ["devices_id"], name: "FK81E459A68294BA3", using: :btree
  add_index "users_devices", ["users_id"], name: "FK81E459A6712480D", using: :btree

  add_foreign_key "devices", "positions", name: "FK5CF8ACDD7C6208C3", column: "latestPosition_id"

  add_foreign_key "positions", "devices", name: "FK65C08C6ADB0C3B8A"

  add_foreign_key "users", "user_settings", name: "FK6A68E0862018CAA", column: "userSettings_id"

  add_foreign_key "users_devices", "devices", name: "FK81E459A68294BA3", column: "devices_id"
  add_foreign_key "users_devices", "users", name: "FK81E459A6712480D", column: "users_id"

end
