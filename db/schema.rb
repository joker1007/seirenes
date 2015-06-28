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

ActiveRecord::Schema.define(version: 20150628113429) do

  create_table "download_lists", force: :cascade do |t|
    t.string   "url",        limit: 255,                null: false
    t.boolean  "download",   limit: 1,   default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id",     limit: 4, null: false
    t.integer  "pasokara_id", limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["pasokara_id"], name: "index_favorites_on_pasokara_id", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "histories", force: :cascade do |t|
    t.integer  "pasokara_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "histories", ["pasokara_id"], name: "index_histories_on_pasokara_id", using: :btree
  add_index "histories", ["user_id"], name: "index_histories_on_user_id", using: :btree

  create_table "pasokaras", force: :cascade do |t|
    t.string   "title",             limit: 255,             null: false
    t.string   "fullpath",          limit: 255,             null: false
    t.string   "nico_vid",          limit: 20
    t.datetime "nico_posted_at"
    t.integer  "nico_view_count",   limit: 4,   default: 0, null: false
    t.integer  "nico_mylist_count", limit: 4,   default: 0, null: false
    t.integer  "duration",          limit: 4
    t.string   "nico_description",  limit: 700
    t.string   "thumbnail",         limit: 255
    t.string   "movie_mp4",         limit: 255
    t.string   "movie_webm",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pasokaras", ["fullpath"], name: "index_pasokaras_on_fullpath", unique: true, using: :btree
  add_index "pasokaras", ["nico_vid"], name: "index_pasokaras_on_nico_vid", unique: true, using: :btree
  add_index "pasokaras", ["title"], name: "index_pasokaras_on_title", using: :btree

  create_table "recorded_songs", force: :cascade do |t|
    t.string   "data",        limit: 255
    t.boolean  "public_flag", limit: 1
    t.integer  "user_id",     limit: 4
    t.integer  "pasokara_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recorded_songs", ["pasokara_id"], name: "index_recorded_songs_on_pasokara_id", using: :btree
  add_index "recorded_songs", ["user_id"], name: "index_recorded_songs_on_user_id", using: :btree

  create_table "song_queues", force: :cascade do |t|
    t.integer  "pasokara_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "song_queues", ["pasokara_id"], name: "index_song_queues_on_pasokara_id", using: :btree
  add_index "song_queues", ["user_id"], name: "index_song_queues_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree

  create_table "user_auths", force: :cascade do |t|
    t.string   "provider",   limit: 255, null: false
    t.string   "uid",        limit: 255, null: false
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_auths", ["provider", "uid"], name: "index_user_auths_on_provider_and_uid", unique: true, using: :btree
  add_index "user_auths", ["user_id"], name: "index_user_auths_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "screen_name", limit: 255,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",       limit: 1,   default: false, null: false
  end

end
