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

ActiveRecord::Schema.define(version: 20130302123143) do

  create_table "pasokaras", force: true do |t|
    t.string   "name",                          null: false
    t.string   "fullpath",                      null: false
    t.string   "md5_hash",                      null: false
    t.string   "nico_vid"
    t.datetime "nico_posted_at"
    t.integer  "nico_view_count",   default: 0, null: false
    t.integer  "nico_mylist_count", default: 0, null: false
    t.integer  "duration"
    t.string   "nico_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_auths", force: true do |t|
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_auths", ["user_id"], name: "index_user_auths_on_user_id"

  create_table "users", force: true do |t|
    t.string   "screen_name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
