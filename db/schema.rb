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

ActiveRecord::Schema.define(version: 20140721134547) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "notification_instances", force: true do |t|
    t.integer  "notification_sample_id"
    t.integer  "month_offset"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_instances", ["notification_sample_id"], name: "index_notification_instances_on_notification_sample_id", using: :btree

  create_table "notification_samples", force: true do |t|
    t.integer  "notification_id"
    t.datetime "datetime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notification_samples", ["notification_id"], name: "index_notification_samples_on_notification_id", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "to"
    t.text     "text"
    t.integer  "start_month"
    t.integer  "start_year"
    t.string   "timezone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.integer  "notification_id"
    t.integer  "month_offset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["notification_id"], name: "index_payments_on_notification_id", using: :btree

end
