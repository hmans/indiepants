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

ActiveRecord::Schema.define(version: 20150201105121) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "posts", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "host",                       null: false
    t.string   "type"
    t.string   "slug"
    t.string   "url"
    t.string   "previous_urls", default: [],              array: true
    t.jsonb    "data",          default: {}, null: false
    t.text     "html"
    t.datetime "published_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "posts", ["created_at"], name: "index_posts_on_created_at", using: :btree
  add_index "posts", ["previous_urls"], name: "index_posts_on_previous_urls", using: :gin
  add_index "posts", ["published_at"], name: "index_posts_on_published_at", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "host",                            null: false
    t.string   "url",                             null: false
    t.string   "password_digest"
    t.boolean  "local",           default: false, null: false
    t.string   "name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["host"], name: "index_users_on_host", unique: true, using: :btree

end
