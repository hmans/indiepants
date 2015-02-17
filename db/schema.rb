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

ActiveRecord::Schema.define(version: 20150216180849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "pants_documents", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "user_id"
    t.string   "path",                        null: false
    t.string   "type"
    t.string   "title"
    t.string   "slug"
    t.string   "previous_paths", default: [],              array: true
    t.text     "html"
    t.jsonb    "data",           default: {}, null: false
    t.string   "tags",           default: [],              array: true
    t.datetime "published_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "pants_documents", ["created_at"], name: "index_pants_documents_on_created_at", using: :btree
  add_index "pants_documents", ["deleted_at"], name: "index_pants_documents_on_deleted_at", using: :btree
  add_index "pants_documents", ["published_at"], name: "index_pants_documents_on_published_at", using: :btree
  add_index "pants_documents", ["tags"], name: "index_pants_documents_on_tags", using: :btree
  add_index "pants_documents", ["user_id", "path"], name: "index_pants_documents_on_user_id_and_path", unique: true, using: :btree
  add_index "pants_documents", ["user_id", "previous_paths"], name: "index_pants_documents_on_user_id_and_previous_paths", using: :btree

  create_table "pants_links", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.uuid     "source_id",   null: false
    t.string   "source_type", null: false
    t.uuid     "target_id",   null: false
    t.string   "target_type", null: false
    t.string   "rel"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "pants_links", ["source_id", "source_type", "target_id", "target_type", "rel"], name: "source_and_target", using: :btree
  add_index "pants_links", ["target_id", "target_type", "rel"], name: "index_pants_links_on_target_id_and_target_type_and_rel", using: :btree

  create_table "pants_users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "host",                             null: false
    t.string   "scheme",          default: "http", null: false
    t.string   "password_digest"
    t.boolean  "local",           default: false,  null: false
    t.string   "name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
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

  add_foreign_key "pants_documents", "pants_users", column: "user_id"
end
