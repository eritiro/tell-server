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

ActiveRecord::Schema.define(version: 20141211161250) do

  create_table "events", force: true do |t|
    t.string   "event_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "ip"
    t.string   "user_agent"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "feeds", force: true do |t|
    t.string   "title"
    t.string   "detail"
    t.string   "action"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds_users", id: false, force: true do |t|
    t.integer "feed_id"
    t.integer "user_id"
  end

  add_index "feeds_users", ["feed_id", "user_id"], name: "index_feeds_users_on_feed_id_and_user_id", unique: true, using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "capacity"
    t.text     "description"
    t.string   "alternative_name"
    t.integer  "relevance"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "from_deleted", default: false
    t.boolean  "to_deleted",   default: false
  end

  add_index "messages", ["from_id"], name: "index_messages_on_from_id", using: :btree
  add_index "messages", ["to_id"], name: "index_messages_on_to_id", using: :btree

  create_table "notifications", force: true do |t|
    t.string   "type"
    t.integer  "from_id"
    t.integer  "to_id"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.boolean  "read",       default: false
  end

  add_index "notifications", ["from_id"], name: "index_notifications_on_from_id", using: :btree
  add_index "notifications", ["to_id"], name: "index_notifications_on_to_id", using: :btree

  create_table "user_photos", force: true do |t|
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_photos", ["user_id"], name: "index_user_photos_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email",                                  null: false
    t.string   "encrypted_password",                     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "authentication_token"
    t.boolean  "admin",                  default: false, null: false
    t.boolean  "completed_tutorial",     default: false
    t.string   "gender"
    t.date     "birthday"
    t.string   "device_token"
    t.integer  "location_id"
    t.boolean  "fake",                   default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "name"
    t.text     "hipotesis"
    t.string   "blog_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "version_number"
    t.boolean  "has_landing"
  end

end
