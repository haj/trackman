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

ActiveRecord::Schema.define(version: 20140715074256) do

  create_table "alarms", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alarms_cars", force: true do |t|
    t.integer  "car_id",     null: false
    t.integer  "alarm_id",   null: false
    t.string   "status"
    t.datetime "last_alert"
  end

  add_index "alarms_cars", ["car_id", "alarm_id"], name: "index_alarms_cars_on_car_id_and_alarm_id", unique: true

  create_table "alarms_groups", force: true do |t|
    t.integer  "group_id",   null: false
    t.integer  "alarm_id",   null: false
    t.string   "status"
    t.datetime "last_alert"
  end

  add_index "alarms_groups", ["group_id", "alarm_id"], name: "index_alarms_groups_on_group_id_and_alarm_id", unique: true

  create_table "alarms_rules", force: true do |t|
    t.integer "rule_id",     null: false
    t.integer "alarm_id",    null: false
    t.string  "conjunction"
    t.string  "params"
  end

  add_index "alarms_rules", ["alarm_id", "rule_id"], name: "index_alarms_rules_on_alarm_id_and_rule_id", unique: true

  create_table "car_manufacturers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_models", force: true do |t|
    t.string   "name"
    t.integer  "car_manufacturer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cars", force: true do |t|
    t.float    "mileage"
    t.string   "numberplate"
    t.integer  "car_model_id"
    t.integer  "car_type_id"
    t.string   "registration_no"
    t.integer  "year"
    t.string   "color"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.integer  "work_schedule_id"
  end

  create_table "cars_work_schedules", id: false, force: true do |t|
    t.integer "car_id",           null: false
    t.integer "work_schedule_id", null: false
  end

  add_index "cars_work_schedules", ["car_id", "work_schedule_id"], name: "index_cars_work_schedules_on_car_id_and_work_schedule_id", unique: true

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "subdomain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "plan_id"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "device_manufacturers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_models", force: true do |t|
    t.string   "name"
    t.integer  "device_manufacturer_id"
    t.string   "protocol"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devices", force: true do |t|
    t.string   "name"
    t.string   "emei"
    t.float    "cost_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "device_model_id"
    t.integer  "device_type_id"
    t.integer  "car_id"
    t.integer  "company_id"
    t.boolean  "movement"
    t.datetime "last_checked"
  end

  create_table "features", force: true do |t|
    t.string   "name"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features_plan_types", force: true do |t|
    t.integer "feature_id",   null: false
    t.integer "plan_type_id", null: false
    t.string  "active"
  end

  add_index "features_plan_types", ["feature_id", "plan_type_id"], name: "index_features_plan_types_on_feature_id_and_plan_type_id", unique: true

  create_table "group_work_hours", force: true do |t|
    t.integer  "day_of_week"
    t.time     "starts_at"
    t.time     "ends_at"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.integer  "work_schedule_id"
  end

  create_table "mailboxer_conversation_opt_outs", force: true do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type"
    t.integer "conversation_id"
  end

  create_table "mailboxer_conversations", force: true do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"

  create_table "mailboxer_receipts", force: true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"

  create_table "parameters", force: true do |t|
    t.string   "name"
    t.string   "data_type"
    t.integer  "rule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plan_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", force: true do |t|
    t.integer  "plan_type_id"
    t.string   "interval"
    t.string   "currency"
    t.float    "price"
    t.string   "paymill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", force: true do |t|
    t.string   "name"
    t.string   "method_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simcards", force: true do |t|
    t.string   "telephone_number"
    t.integer  "teleprovider_id"
    t.float    "monthly_price"
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "states", force: true do |t|
    t.boolean  "no_data",    default: false
    t.boolean  "moving",     default: false
    t.integer  "car_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "speed",      default: 0.0
    t.integer  "driver_id"
    t.integer  "device_id"
  end

  create_table "subscriptions", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "paymill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "plan_id"
  end

  create_table "teleproviders", force: true do |t|
    t.string   "name"
    t.string   "apn"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "company_id"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.integer  "roles_mask"
    t.integer  "car_id"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count"
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "vertices", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "region_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_hours", force: true do |t|
    t.integer  "day_of_week"
    t.time     "starts_at"
    t.time     "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "work_schedule_id"
  end

  add_index "work_hours", ["work_schedule_id"], name: "index_work_hours_on_work_schedule_id"

  create_table "work_schedules", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
