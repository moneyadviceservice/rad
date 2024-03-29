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

ActiveRecord::Schema.define(version: 3019_11_18_100181) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "accreditations", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
  end

  create_table "accreditations_advisers", id: false, force: :cascade do |t|
    t.integer "adviser_id", null: false
    t.integer "accreditation_id", null: false
    t.index ["adviser_id", "accreditation_id"], name: "advisers_accreditations_index", unique: true
  end

  create_table "advisers", id: :serial, force: :cascade do |t|
    t.string "reference_number", null: false
    t.string "name", null: false
    t.integer "firm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "postcode", default: "", null: false
    t.integer "travel_distance", default: 0, null: false
    t.float "latitude"
    t.float "longitude"
    t.boolean "bypass_reference_number_check", default: false
  end

  create_table "advisers_professional_bodies", id: false, force: :cascade do |t|
    t.integer "adviser_id", null: false
    t.integer "professional_body_id", null: false
    t.index ["adviser_id", "professional_body_id"], name: "advisers_professional_bodies_index", unique: true
  end

  create_table "advisers_professional_standings", id: false, force: :cascade do |t|
    t.integer "adviser_id", null: false
    t.integer "professional_standing_id", null: false
    t.index ["adviser_id", "professional_standing_id"], name: "advisers_professional_standings_index", unique: true
  end

  create_table "advisers_qualifications", id: false, force: :cascade do |t|
    t.integer "adviser_id", null: false
    t.integer "qualification_id", null: false
    t.index ["adviser_id", "qualification_id"], name: "advisers_qualifications_index", unique: true
  end

  create_table "allowed_payment_methods", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
  end

  create_table "allowed_payment_methods_firms", id: false, force: :cascade do |t|
    t.integer "firm_id", null: false
    t.integer "allowed_payment_method_id", null: false
    t.index ["firm_id", "allowed_payment_method_id"], name: "firms_allowed_payment_methods_index", unique: true
  end

  create_table "fca_imports", id: :serial, force: :cascade do |t|
    t.string "files", null: false
    t.string "status"
    t.text "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "firms", id: :serial, force: :cascade do |t|
    t.integer "fca_number", null: false
    t.string "registered_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "free_initial_meeting"
    t.integer "initial_meeting_duration_id"
    t.integer "minimum_fixed_fee", default: 0
    t.integer "parent_id"
    t.boolean "retirement_income_products_flag", default: false, null: false
    t.boolean "pension_transfer_flag", default: false, null: false
    t.boolean "long_term_care_flag", default: false, null: false
    t.boolean "equity_release_flag", default: false, null: false
    t.boolean "inheritance_tax_and_estate_planning_flag", default: false, null: false
    t.boolean "wills_and_probate_flag", default: false, null: false
    t.string "website_address"
    t.boolean "ethical_investing_flag", default: false, null: false
    t.boolean "sharia_investing_flag", default: false, null: false
    t.text "languages", default: [], null: false, array: true
    t.integer "status"
    t.boolean "workplace_financial_advice_flag", default: false, null: false
    t.boolean "non_uk_residents_flag", default: false, null: false
    t.datetime "approved_at"
    t.datetime "hidden_at"
    t.index ["approved_at"], name: "index_firms_on_approved_at"
    t.index ["hidden_at"], name: "index_firms_on_hidden_at"
    t.index ["initial_meeting_duration_id"], name: "index_firms_on_initial_meeting_duration_id"
  end

  create_table "firms_in_person_advice_methods", id: false, force: :cascade do |t|
    t.integer "firm_id", null: false
    t.integer "in_person_advice_method_id", null: false
    t.index ["firm_id", "in_person_advice_method_id"], name: "firms_in_person_advice_methods_index", unique: true
  end

  create_table "firms_initial_advice_fee_structures", id: false, force: :cascade do |t|
    t.integer "firm_id", null: false
    t.integer "initial_advice_fee_structure_id", null: false
    t.index ["firm_id", "initial_advice_fee_structure_id"], name: "firms_initial_advice_fee_structures_index", unique: true
  end

  create_table "firms_investment_sizes", id: false, force: :cascade do |t|
    t.integer "firm_id", null: false
    t.integer "investment_size_id", null: false
    t.index ["firm_id", "investment_size_id"], name: "firms_investment_sizes_index", unique: true
  end

  create_table "firms_ongoing_advice_fee_structures", id: false, force: :cascade do |t|
    t.integer "firm_id", null: false
    t.integer "ongoing_advice_fee_structure_id", null: false
    t.index ["firm_id", "ongoing_advice_fee_structure_id"], name: "firms_ongoing_advice_fee_structures_index", unique: true
  end

  create_table "firms_other_advice_methods", id: false, force: :cascade do |t|
    t.integer "firm_id", null: false
    t.integer "other_advice_method_id", null: false
    t.index ["firm_id", "other_advice_method_id"], name: "firms_other_advice_methods_index", unique: true
  end

  create_table "in_person_advice_methods", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
  end

  create_table "inactive_firms", id: :serial, force: :cascade do |t|
    t.string "api_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "firmable_type"
    t.bigint "firmable_id"
    t.index ["firmable_type", "firmable_id"], name: "index_inactive_firms_on_firmable_type_and_firmable_id"
  end

  create_table "initial_advice_fee_structures", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
  end

  create_table "initial_meeting_durations", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
  end

  create_table "investment_sizes", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
    t.string "cy_name"
  end

  create_table "last_week_lookup_advisers", id: :integer, default: nil, force: :cascade do |t|
    t.string "reference_number", limit: 20, null: false
    t.string "name", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "last_week_lookup_firms", id: :integer, default: nil, force: :cascade do |t|
    t.integer "fca_number", null: false
    t.string "registered_name", limit: 255, default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "last_week_lookup_subsidiaries", id: :integer, default: nil, force: :cascade do |t|
    t.integer "fca_number", null: false
    t.string "name", limit: 255, default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lookup_advisers", id: :serial, force: :cascade do |t|
    t.string "reference_number", limit: 20, null: false
    t.string "name", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lookup_firms", id: :serial, force: :cascade do |t|
    t.integer "fca_number", null: false
    t.string "registered_name", limit: 255, default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lookup_subsidiaries", id: :serial, force: :cascade do |t|
    t.integer "fca_number", null: false
    t.string "name", limit: 255, default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medical_specialisms", force: :cascade do |t|
    t.bigint "travel_insurance_firm_id"
    t.string "specialised_medical_conditions_cover"
    t.string "likely_not_cover_medical_condition"
    t.string "cover_undergoing_treatment"
    t.boolean "terminal_prognosis_cover"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "specialised_medical_conditions_covers_all"
    t.boolean "will_not_cover_some_medical_conditions"
    t.boolean "will_cover_undergoing_treatment"
    t.index ["travel_insurance_firm_id"], name: "index_medical_specialisms_on_travel_insurance_firm_id"
  end

  create_table "offices", id: :serial, force: :cascade do |t|
    t.string "address_line_one", null: false
    t.string "address_line_two"
    t.string "address_town", null: false
    t.string "address_county"
    t.string "address_postcode", null: false
    t.string "email_address"
    t.string "telephone_number"
    t.boolean "disabled_access", default: false, null: false
    t.integer "firm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.string "website"
    t.string "officeable_type"
    t.bigint "officeable_id"
    t.index ["officeable_type", "officeable_id"], name: "index_offices_on_officeable_type_and_officeable_id"
  end

  create_table "old_passwords", id: :serial, force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_salt"
    t.string "password_archivable_type", null: false
    t.integer "password_archivable_id", null: false
    t.datetime "created_at"
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "ongoing_advice_fee_structures", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
  end

  create_table "opening_times", force: :cascade do |t|
    t.bigint "office_id"
    t.time "weekday_opening_time"
    t.time "weekday_closing_time"
    t.time "saturday_opening_time"
    t.time "saturday_closing_time"
    t.time "sunday_opening_time"
    t.time "sunday_closing_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["office_id"], name: "index_opening_times_on_office_id"
  end

  create_table "other_advice_methods", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
    t.string "cy_name"
  end

  create_table "principals", id: :serial, force: :cascade do |t|
    t.integer "fca_number"
    t.string "token"
    t.string "first_name"
    t.string "last_name"
    t.string "job_title"
    t.string "email_address"
    t.string "telephone_number"
    t.boolean "confirmed_disclaimer", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "senior_manager_name"
    t.string "individual_reference_number", default: "", null: false
    t.index ["fca_number"], name: "index_principals_on_fca_number", unique: true
    t.index ["token"], name: "index_principals_on_token", unique: true
  end

  create_table "professional_standings", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
  end

  create_table "qualifications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order", default: 0, null: false
  end

  create_table "rad_consumer_sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_rad_consumer_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_rad_consumer_sessions_on_updated_at"
  end

  create_table "service_details", force: :cascade do |t|
    t.bigint "travel_insurance_firm_id"
    t.boolean "offers_telephone_quote"
    t.integer "cover_for_specialist_equipment"
    t.string "medical_screening_company"
    t.string "how_far_in_advance_trip_cover"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "covid19_medical_repatriation"
    t.boolean "covid19_cancellation_cover"
    t.boolean "will_cover_specialist_equipment"
    t.index ["travel_insurance_firm_id"], name: "index_service_details_on_travel_insurance_firm_id"
  end

  create_table "snapshots", id: :serial, force: :cascade do |t|
    t.integer "firms_with_no_minimum_fee"
    t.integer "integer"
    t.integer "firms_with_min_fee_between_1_500"
    t.integer "firms_with_min_fee_between_501_1000"
    t.integer "firms_any_pot_size"
    t.integer "firms_any_pot_size_min_fee_less_than_500"
    t.integer "registered_firms"
    t.integer "published_firms"
    t.integer "firms_offering_face_to_face_advice"
    t.integer "firms_offering_remote_advice"
    t.integer "firms_in_england"
    t.integer "firms_in_scotland"
    t.integer "firms_in_wales"
    t.integer "firms_in_northern_ireland"
    t.integer "firms_providing_retirement_income_products"
    t.integer "firms_providing_pension_transfer"
    t.integer "firms_providing_long_term_care"
    t.integer "firms_providing_equity_release"
    t.integer "firms_providing_inheritance_tax_and_estate_planning"
    t.integer "firms_providing_wills_and_probate"
    t.integer "firms_providing_ethical_investing"
    t.integer "firms_providing_sharia_investing"
    t.integer "firms_offering_languages_other_than_english"
    t.integer "offices_with_disabled_access"
    t.integer "registered_advisers"
    t.integer "advisers_in_england"
    t.integer "advisers_in_scotland"
    t.integer "advisers_in_wales"
    t.integer "advisers_in_northern_ireland"
    t.integer "advisers_who_travel_5_miles"
    t.integer "advisers_who_travel_10_miles"
    t.integer "advisers_who_travel_25_miles"
    t.integer "advisers_who_travel_50_miles"
    t.integer "advisers_who_travel_100_miles"
    t.integer "advisers_who_travel_150_miles"
    t.integer "advisers_who_travel_200_miles"
    t.integer "advisers_who_travel_250_miles"
    t.integer "advisers_who_travel_uk_wide"
    t.integer "advisers_accredited_in_solla"
    t.integer "advisers_accredited_in_later_life_academy"
    t.integer "advisers_accredited_in_iso22222"
    t.integer "advisers_accredited_in_bs8577"
    t.integer "advisers_with_qualification_in_level_4"
    t.integer "advisers_with_qualification_in_level_6"
    t.integer "advisers_with_qualification_in_chartered_financial_planner"
    t.integer "advisers_with_qualification_in_certified_financial_planner"
    t.integer "advisers_with_qualification_in_pension_transfer"
    t.integer "advisers_with_qualification_in_equity_release"
    t.integer "advisers_with_qualification_in_long_term_care_planning"
    t.integer "advisers_with_qualification_in_tep"
    t.integer "advisers_with_qualification_in_fcii"
    t.integer "advisers_part_of_personal_finance_society"
    t.integer "advisers_part_of_institute_financial_planning"
    t.integer "advisers_part_of_institute_financial_services"
    t.integer "advisers_part_of_ci_bankers_scotland"
    t.integer "advisers_part_of_ci_securities_and_investments"
    t.integer "advisers_part_of_cfa_institute"
    t.integer "advisers_part_of_chartered_accountants"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "firms_providing_workplace_financial_advice", default: 0
    t.integer "firms_providing_non_uk_residents", default: 0
    t.integer "advisers_with_qualification_in_chartered_associate", default: 0
    t.integer "advisers_with_qualification_in_chartered_fellow", default: 0
  end

  create_table "travel_insurance_firms", force: :cascade do |t|
    t.integer "fca_number", null: false
    t.string "registered_name", null: false
    t.datetime "approved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "covers_medical_condition_question"
    t.string "covered_by_ombudsman_question"
    t.string "risk_profile_approach_question"
    t.string "metastatic_breast_cancer_question"
    t.string "ulceritive_colitis_and_anaemia_question"
    t.string "heart_attack_with_hbp_and_high_cholesterol_question"
    t.string "copd_with_respiratory_infection_question"
    t.string "motor_neurone_disease_question"
    t.string "hodgkin_lymphoma_question"
    t.string "acute_myeloid_leukaemia_question"
    t.string "guillain_barre_syndrome_question"
    t.string "heart_failure_and_arrhytmia_question"
    t.string "stroke_with_hbp_question"
    t.string "peripheral_vascular_disease_question"
    t.string "schizophrenia_question"
    t.string "lupus_question"
    t.string "sickle_cell_and_renal_question"
    t.string "sub_arachnoid_haemorrhage_and_epilepsy_question"
    t.integer "parent_id"
    t.text "website_address"
    t.datetime "hidden_at"
    t.string "supplies_documentation_when_needed_question"
    t.index ["approved_at"], name: "index_travel_insurance_firms_on_approved_at"
    t.index ["fca_number"], name: "index_travel_insurance_firms_on_fca_number"
    t.index ["hidden_at"], name: "index_travel_insurance_firms_on_hidden_at"
  end

  create_table "trip_covers", force: :cascade do |t|
    t.bigint "travel_insurance_firm_id"
    t.string "trip_type"
    t.string "cover_area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "land_30_days_max_age"
    t.integer "cruise_30_days_max_age"
    t.integer "land_45_days_max_age"
    t.integer "cruise_45_days_max_age"
    t.integer "land_55_days_max_age"
    t.integer "cruise_55_days_max_age"
    t.integer "land_50_days_max_age"
    t.integer "cruise_50_days_max_age"
    t.index ["travel_insurance_firm_id"], name: "index_trip_covers_on_travel_insurance_firm_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "principal_token"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.integer "invitations_count", default: 0
    t.datetime "password_changed_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "medical_specialisms", "travel_insurance_firms"
  add_foreign_key "opening_times", "offices"
  add_foreign_key "service_details", "travel_insurance_firms"
  add_foreign_key "trip_covers", "travel_insurance_firms"
end
