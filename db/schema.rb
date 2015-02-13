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

ActiveRecord::Schema.define(version: 20150207193808) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "posts", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "host",                         null: false
    t.string   "type"
    t.string   "slug"
    t.string   "url"
    t.string   "previous_urls",   default: [],              array: true
    t.string   "referenced_urls", default: [],              array: true
    t.text     "html"
    t.jsonb    "data",            default: {}, null: false
    t.string   "tags",            default: [],              array: true
    t.datetime "published_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "posts", ["created_at"], name: "index_posts_on_created_at", using: :btree
  add_index "posts", ["deleted_at"], name: "index_posts_on_deleted_at", using: :btree
  add_index "posts", ["previous_urls"], name: "index_posts_on_previous_urls", using: :btree
  add_index "posts", ["published_at"], name: "index_posts_on_published_at", using: :btree
  add_index "posts", ["referenced_urls"], name: "index_posts_on_referenced_urls", using: :btree
  add_index "posts", ["tags"], name: "index_posts_on_tags", using: :btree

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

  create_table "webmentions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "source"
    t.string   "target"
    t.uuid     "source_post_id"
    t.uuid     "target_post_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "webmentions", ["source_post_id"], name: "index_webmentions_on_source_post_id", using: :btree
  add_index "webmentions", ["target_post_id"], name: "index_webmentions_on_target_post_id", using: :btree
  add_index "webmentions", ["user_id"], name: "index_webmentions_on_user_id", using: :btree

end
