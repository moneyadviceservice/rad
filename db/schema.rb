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

ActiveRecord::Schema.define(version: 20150121134845) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advisers", force: :cascade do |t|
    t.string   "reference_number", null: false
    t.string   "name",             null: false
    t.integer  "firm_id",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "advisers_qualifications", id: false, force: :cascade do |t|
    t.integer "adviser_id",       null: false
    t.integer "qualification_id", null: false
  end

  add_index "advisers_qualifications", ["adviser_id", "qualification_id"], name: "advisers_qualifications_index", unique: true, using: :btree

  create_table "firms", force: :cascade do |t|
    t.integer  "fca_number",      null: false
    t.string   "registered_name", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "firms", ["fca_number"], name: "index_firms_on_fca_number", unique: true, using: :btree

  create_table "lookup_advisers", force: :cascade do |t|
    t.string   "reference_number", null: false
    t.string   "name",             null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "lookup_firms", force: :cascade do |t|
    t.integer  "fca_number",                               null: false
    t.string   "registered_name", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lookup_firms", ["fca_number"], name: "index_lookup_firms_on_fca_number", unique: true, using: :btree

  create_table "lookup_subsidiaries", force: :cascade do |t|
    t.integer  "fca_number",              null: false
    t.string   "name",       default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "lookup_subsidiaries", ["fca_number"], name: "index_lookup_subsidiaries_on_fca_number", using: :btree

  create_table "principals", force: :cascade do |t|
    t.integer  "fca_number"
    t.string   "token",                limit: 255
    t.string   "website_address",      limit: 255
    t.string   "first_name",           limit: 255
    t.string   "last_name",            limit: 255
    t.string   "job_title",            limit: 255
    t.string   "email_address",        limit: 255
    t.string   "telephone_number",     limit: 255
    t.boolean  "confirmed_disclaimer",             default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "principals", ["fca_number"], name: "index_principals_on_fca_number", unique: true, using: :btree
  add_index "principals", ["token"], name: "index_principals_on_token", unique: true, using: :btree

  create_table "qualifications", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
