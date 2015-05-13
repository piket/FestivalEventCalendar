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

ActiveRecord::Schema.define(version: 20150512234020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "subject"
    t.text     "body"
    t.boolean  "unread"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "original_id"
    t.integer  "festival_id"
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "event_occurrences", force: :cascade do |t|
    t.datetime "date"
    t.string   "location"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "event_occurrences", ["event_id"], name: "index_event_occurrences_on_event_id", using: :btree

  create_table "event_occurrences_users", force: :cascade do |t|
    t.integer  "event_occurrence_id"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "event_occurrences_users", ["event_occurrence_id"], name: "index_event_occurrences_users_on_event_occurrence_id", using: :btree
  add_index "event_occurrences_users", ["user_id"], name: "index_event_occurrences_users_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image"
    t.string   "video"
    t.string   "link"
    t.string   "purchase"
    t.float    "price"
    t.integer  "host_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "duration"
  end

  add_index "events", ["host_id"], name: "index_events_on_host_id", using: :btree

  create_table "events_tags", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "events_tags", ["event_id"], name: "index_events_tags_on_event_id", using: :btree
  add_index "events_tags", ["tag_id"], name: "index_events_tags_on_tag_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer "friendable_id"
    t.integer "friend_id"
    t.integer "blocker_id"
    t.boolean "pending",       default: true
  end

  add_index "friendships", ["friendable_id", "friend_id"], name: "index_friendships_on_friendable_id_and_friend_id", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "user_type"
    t.string   "gender"
    t.string   "location"
    t.string   "age"
    t.boolean  "status"
    t.string   "provider"
    t.string   "provider_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "provider_hash"
    t.string   "image"
    t.text     "about"
  end

  add_foreign_key "comments", "users"
  add_foreign_key "event_occurrences", "events"
  add_foreign_key "event_occurrences_users", "event_occurrences"
  add_foreign_key "event_occurrences_users", "users"
  add_foreign_key "events_tags", "events"
  add_foreign_key "events_tags", "tags"
end
