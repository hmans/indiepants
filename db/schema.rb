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

  create_table "pants_documents", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "url",                        null: false
    t.string   "host",                       null: false
    t.string   "path",                       null: false
    t.string   "type"
    t.string   "title"
    t.string   "slug"
    t.string   "previous_urls", default: [],              array: true
    t.text     "html"
    t.json     "data",          default: {}, null: false
    t.string   "tags",          default: [],              array: true
    t.datetime "published_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "pants_documents", ["created_at"], name: "index_pants_documents_on_created_at", using: :btree
  add_index "pants_documents", ["deleted_at"], name: "index_pants_documents_on_deleted_at", using: :btree
  add_index "pants_documents", ["host"], name: "index_pants_documents_on_host", using: :btree
  add_index "pants_documents", ["previous_urls"], name: "index_pants_documents_on_previous_urls", using: :btree
  add_index "pants_documents", ["published_at"], name: "index_pants_documents_on_published_at", using: :btree
  add_index "pants_documents", ["tags"], name: "index_pants_documents_on_tags", using: :btree

  create_table "pants_users", force: :cascade do |t|
    t.string   "url",                             null: false
    t.string   "host",                            null: false
    t.string   "password_digest"
    t.boolean  "local",           default: false, null: false
    t.string   "name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "pants_users", ["host"], name: "index_pants_users_on_host", unique: true, using: :btree

  create_table "pants_webmentions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "source"
    t.string   "target"
    t.uuid     "source_document_id"
    t.uuid     "target_document_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "pants_webmentions", ["source_document_id"], name: "index_pants_webmentions_on_source_document_id", using: :btree
  add_index "pants_webmentions", ["target_document_id"], name: "index_pants_webmentions_on_target_document_id", using: :btree

end
