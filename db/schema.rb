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

ActiveRecord::Schema.define(version: 20141216142455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "lookup_firms", force: true do |t|
    t.integer  "fca_number",                   null: false
    t.string   "registered_name", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lookup_firms", ["fca_number"], name: "index_lookup_firms_on_fca_number", unique: true, using: :btree

  create_table "principals", force: true do |t|
    t.string   "token",           limit: 32, null: false
    t.datetime "last_sign_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "principals", ["token"], name: "index_principals_on_token", unique: true, using: :btree

end
