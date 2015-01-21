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

ActiveRecord::Schema.define(version: 20150121165612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allowed_payment_methods", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "allowed_payment_methods_firms", id: false, force: :cascade do |t|
    t.integer "firm_id"
    t.integer "allowed_payment_method_id"
  end

  add_index "allowed_payment_methods_firms", ["allowed_payment_method_id"], name: "allowed_payment_methods_firms_allowed_payment_method_id", using: :btree
  add_index "allowed_payment_methods_firms", ["firm_id"], name: "index_allowed_payment_methods_firms_on_firm_id", using: :btree

  create_table "firms", force: :cascade do |t|
    t.string   "email_address",                               null: false
    t.string   "telephone_number",                            null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "address_line_1",                              null: false
    t.string   "address_line_2",                              null: false
    t.string   "address_town",                                null: false
    t.string   "address_county",                              null: false
    t.string   "address_postcode",                            null: false
    t.boolean  "free_initial_meeting",                        null: false
    t.integer  "initial_meeting_duration_id"
    t.integer  "minimum_fixed_fee"
    t.integer  "investment_size_id"
    t.integer  "retirement_income_products_percent",          null: false
    t.integer  "pension_transfer_percent",                    null: false
    t.integer  "long_term_care_percent",                      null: false
    t.integer  "equity_release_percent",                      null: false
    t.integer  "inheritance_tax_and_estate_planning_percent", null: false
    t.integer  "wills_and_probate_percent",                   null: false
    t.integer  "other_percent",                               null: false
  end

  add_index "firms", ["initial_meeting_duration_id"], name: "index_firms_on_initial_meeting_duration_id", using: :btree
  add_index "firms", ["investment_size_id"], name: "index_firms_on_investment_size_id", using: :btree

  create_table "firms_in_person_advice_methods", id: false, force: :cascade do |t|
    t.integer "firm_id"
    t.integer "in_person_advice_method_id"
  end

  add_index "firms_in_person_advice_methods", ["firm_id"], name: "in_person_advice_methods_firm_id", using: :btree
  add_index "firms_in_person_advice_methods", ["in_person_advice_method_id"], name: "in_person_advice_methods_in_person_advice_method_id", using: :btree

  create_table "firms_initial_advice_fee_structures", id: false, force: :cascade do |t|
    t.integer "firm_id"
    t.integer "initial_advice_fee_structure_id"
  end

  add_index "firms_initial_advice_fee_structures", ["firm_id"], name: "index_firms_initial_advice_fee_structures_on_firm_id", using: :btree
  add_index "firms_initial_advice_fee_structures", ["initial_advice_fee_structure_id"], name: "firms_initial_advice_fee_structs_initial_advice_fee_struct_id", using: :btree

  create_table "firms_investment_sizes", id: false, force: :cascade do |t|
    t.integer "firm_id"
    t.integer "investment_size_id"
  end

  add_index "firms_investment_sizes", ["firm_id"], name: "index_firms_investment_sizes_on_firm_id", using: :btree
  add_index "firms_investment_sizes", ["investment_size_id"], name: "index_firms_investment_sizes_on_investment_size_id", using: :btree

  create_table "firms_ongoing_advice_fee_structures", id: false, force: :cascade do |t|
    t.integer "firm_id"
    t.integer "ongoing_advice_fee_structure_id"
  end

  add_index "firms_ongoing_advice_fee_structures", ["firm_id"], name: "index_firms_ongoing_advice_fee_structures_on_firm_id", using: :btree
  add_index "firms_ongoing_advice_fee_structures", ["ongoing_advice_fee_structure_id"], name: "firms_ongoing_advice_fee_structs_ongoing_advice_fee_struct_id", using: :btree

  create_table "firms_other_advice_methods", id: false, force: :cascade do |t|
    t.integer "firm_id"
    t.integer "other_advice_method_id"
  end

  add_index "firms_other_advice_methods", ["firm_id"], name: "index_firms_other_advice_methods_on_firm_id", using: :btree
  add_index "firms_other_advice_methods", ["other_advice_method_id"], name: "index_firms_other_advice_methods_on_other_advice_method_id", using: :btree

  create_table "in_person_advice_methods", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "in_person_advice_methods", ["name"], name: "index_in_person_advice_methods_on_name", using: :btree

  create_table "initial_advice_fee_structures", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "initial_meeting_durations", force: :cascade do |t|
    t.integer  "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "investment_sizes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lookup_advisers", force: :cascade do |t|
    t.string   "reference_number", null: false
    t.string   "name",             null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "lookup_firms", force: :cascade do |t|
    t.integer  "fca_number",                   null: false
    t.string   "registered_name", default: "", null: false
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

  create_table "ongoing_advice_fee_structures", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "other_advice_methods", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "principals", force: :cascade do |t|
    t.integer  "fca_number"
    t.string   "token"
    t.string   "website_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.string   "email_address"
    t.string   "telephone_number"
    t.boolean  "confirmed_disclaimer", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "principals", ["fca_number"], name: "index_principals_on_fca_number", unique: true, using: :btree
  add_index "principals", ["token"], name: "index_principals_on_token", unique: true, using: :btree

  create_table "service_regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "service_regions", ["name"], name: "index_service_regions_on_name", unique: true, using: :btree

  add_foreign_key "firms", "investment_sizes"
end
