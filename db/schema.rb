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

ActiveRecord::Schema.define(version: 20160208015856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "addresses", ["user_id"], name: "index_addresses_on_user_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "email"
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  add_index "admin_users", ["uid", "provider"], name: "index_admin_users_on_uid_and_provider", unique: true, using: :btree

  create_table "blood_pressures", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "systolic"
    t.float    "diastolic"
    t.string   "units",      default: "mm/HG"
    t.datetime "created_at"
  end

  add_index "blood_pressures", ["user_id"], name: "index_blood_pressures_on_user_id", using: :btree

  create_table "data_import_ndc_packages", force: :cascade do |t|
    t.string "PRODUCTID",          limit: 48
    t.string "PRODUCTNDC"
    t.string "NDCPACKAGECODE"
    t.string "PACKAGEDESCRIPTION"
  end

  create_table "data_import_ndc_products", force: :cascade do |t|
    t.string "PRODUCTID"
    t.string "PRODUCTNDC"
    t.string "PRODUCTTYPENAME"
    t.string "PROPRIETARYNAME"
    t.string "PROPRIETARYNAMESUFFIX"
    t.string "NONPROPRIETARYNAME"
    t.string "DOSAGEFORMNAME"
    t.string "ROUTENAME"
    t.string "STARTMARKETINGDATE"
    t.string "ENDMARKETINGDATE"
    t.string "MARKETINGCATEGORYNAME"
    t.string "APPLICATIONNUMBER"
    t.string "LABELERNAME"
    t.string "SUBSTANCENAME"
    t.string "ACTIVE_NUMERATOR_STRENGTH"
    t.string "ACTIVE_INGRED_UNIT"
    t.string "PHARM_CLASSES"
    t.string "DEASCHEDULE"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "geonames", force: :cascade do |t|
    t.string    "zip"
    t.string    "city"
    t.string    "state"
    t.string    "county"
    t.geography "lonlat",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.datetime  "created_at",                                                          null: false
    t.datetime  "updated_at",                                                          null: false
  end

  add_index "geonames", ["zip"], name: "index_geonames_on_zip", using: :btree

  create_table "glucose_strip_bottles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "strip_count"
    t.date     "expiration"
    t.date     "opened"
    t.string   "lot_number"
    t.boolean  "current"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "glucose_strip_bottles", ["user_id"], name: "index_glucose_strip_bottles_on_user_id", using: :btree

  create_table "glucoses", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "value"
    t.string   "units",      default: "mg/dL"
    t.jsonb    "activities", default: []
    t.string   "notes"
    t.boolean  "is_control", default: false
    t.datetime "created_at"
  end

  add_index "glucoses", ["user_id"], name: "index_glucoses_on_user_id", using: :btree

  create_table "insurances", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "company_name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "plan_code"
    t.string   "id_number"
    t.string   "group_number"
    t.string   "rx_bin"
    t.string   "rx_pcn"
    t.string   "rx_group"
    t.string   "coverage"
    t.float    "office_copay"
    t.float    "specialist_copay"
    t.float    "annual_deductible"
    t.date     "deductible_effective_date"
    t.string   "member_servies_phone"
    t.string   "provider_services_phone"
    t.string   "pharmacist_services_phone"
    t.string   "nurse_line_phone"
    t.string   "website"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "insurances", ["user_id"], name: "index_insurances_on_user_id", using: :btree

  create_table "med_entries", force: :cascade do |t|
    t.integer  "medication_id"
    t.integer  "reminder_id"
    t.integer  "user_id"
    t.boolean  "taken",          default: false
    t.datetime "scheduled_time"
    t.datetime "actual_time"
  end

  add_index "med_entries", ["medication_id"], name: "index_med_entries_on_medication_id", using: :btree
  add_index "med_entries", ["reminder_id"], name: "index_med_entries_on_reminder_id", using: :btree
  add_index "med_entries", ["user_id"], name: "index_med_entries_on_user_id", using: :btree

  create_table "medications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "dose"
    t.integer  "frequency"
    t.string   "frequency_period"
    t.string   "strength"
    t.float    "refills_remaining"
    t.date     "discard_date"
    t.string   "reason_for_taking"
    t.string   "form"
    t.integer  "count"
    t.string   "route"
    t.string   "category"
    t.string   "description"
    t.string   "instructions"
    t.string   "ndc"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "prescriber_id"
    t.integer  "pharmacy_id"
  end

  add_index "medications", ["pharmacy_id"], name: "index_medications_on_pharmacy_id", using: :btree
  add_index "medications", ["prescriber_id"], name: "index_medications_on_prescriber_id", using: :btree
  add_index "medications", ["user_id"], name: "index_medications_on_user_id", using: :btree

  create_table "ndc_packages", force: :cascade do |t|
    t.integer "ndc_product_id"
    t.string  "ndc_product_code", limit: 10
    t.string  "ndc_package_code", limit: 13
    t.string  "fda_native_code",  limit: 13
    t.string  "description"
  end

  add_index "ndc_packages", ["ndc_package_code"], name: "index_ndc_packages_on_ndc_package_code", using: :btree
  add_index "ndc_packages", ["ndc_product_id"], name: "index_ndc_packages_on_ndc_product_id", using: :btree

  create_table "ndc_products", force: :cascade do |t|
    t.string "product_id",                limit: 48
    t.string "product_ndc",               limit: 10
    t.string "product_type_name",         limit: 32
    t.string "proprietary_name",          limit: 256
    t.string "proprietary_name_suffix",   limit: 128
    t.string "nonproprietary_name",       limit: 512
    t.string "dosage_form_name",          limit: 64
    t.string "route_name",                limit: 196
    t.date   "start_marketing_date"
    t.date   "end_marketing_date"
    t.string "marketing_category_name",   limit: 48
    t.string "application_number",        limit: 11
    t.string "label_name",                limit: 128
    t.string "substance_name"
    t.string "active_numerator_strength"
    t.string "active_ingred_unit"
    t.string "pharm_classes"
    t.string "dea_schedule",              limit: 8
  end

  add_index "ndc_products", ["product_id"], name: "index_ndc_products_on_product_id", unique: true, using: :btree
  add_index "ndc_products", ["product_ndc"], name: "index_ndc_products_on_product_ndc", using: :btree

  create_table "pending_insurance_cards", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status"
    t.jsonb    "images"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "pending_insurance_cards", ["user_id"], name: "index_pending_insurance_cards_on_user_id", using: :btree

  create_table "pending_medications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status"
    t.jsonb    "images"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "pending_medications", ["user_id"], name: "index_pending_medications_on_user_id", using: :btree

  create_table "pending_recommended_links", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prescription_requests", force: :cascade do |t|
    t.integer  "medication_id"
    t.integer  "user_id"
    t.integer  "provider_id"
    t.string   "status"
    t.string   "note"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prescription_requests", ["medication_id"], name: "index_prescription_requests_on_medication_id", using: :btree
  add_index "prescription_requests", ["provider_id"], name: "index_prescription_requests_on_provider_id", using: :btree
  add_index "prescription_requests", ["user_id"], name: "index_prescription_requests_on_user_id", using: :btree

  create_table "provider_identifiers", force: :cascade do |t|
    t.string   "provider_id"
    t.string   "license_number",  limit: 20
    t.string   "additional_info"
    t.string   "identifier"
    t.string   "state",           limit: 2
    t.string   "type_code",       limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provider_taxonomies", force: :cascade do |t|
    t.integer  "provider_id"
    t.string   "code",        limit: 10
    t.string   "taxonomy"
    t.boolean  "primary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provider_taxonomies", ["code"], name: "index_provider_taxonomies_on_code", using: :btree
  add_index "provider_taxonomies", ["provider_id"], name: "index_provider_taxonomies_on_provider_id", using: :btree

  create_table "provider_users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
    t.string   "email"
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "provider_id"
  end

  add_index "provider_users", ["email"], name: "index_provider_users_on_email", using: :btree
  add_index "provider_users", ["provider_id"], name: "index_provider_users_on_provider_id", using: :btree
  add_index "provider_users", ["reset_password_token"], name: "index_provider_users_on_reset_password_token", unique: true, using: :btree
  add_index "provider_users", ["uid", "provider"], name: "index_provider_users_on_uid_and_provider", unique: true, using: :btree

  create_table "providers", primary_key: "npi", force: :cascade do |t|
    t.integer   "entity_type_code"
    t.string    "replacement_npi"
    t.string    "employer_identification_number",            limit: 9
    t.string    "organization_name",                         limit: 70
    t.string    "last_name",                                 limit: 35
    t.string    "first_name",                                limit: 20
    t.string    "middle_name",                               limit: 20
    t.string    "name_prefix_text",                          limit: 5
    t.string    "name_suffix_text",                          limit: 5
    t.string    "credential_text",                           limit: 20
    t.string    "other_organization_name",                   limit: 70
    t.string    "other_organization_name_type_code",         limit: 1
    t.string    "other_last_name",                           limit: 35
    t.string    "other_first_name",                          limit: 20
    t.string    "other_middle_name",                         limit: 20
    t.string    "other_name_prefix_text",                    limit: 5
    t.string    "other_name_suffix_text",                    limit: 5
    t.string    "other_credential_text",                     limit: 20
    t.string    "other_last_name_type_code",                 limit: 1
    t.string    "first_line_business_address",               limit: 55
    t.string    "business_mailing_address_city_name",        limit: 40
    t.string    "mailing_address_state_name",                limit: 40
    t.string    "business_mailing_address_postal_code",      limit: 20
    t.string    "business_mailing_address_country_code",     limit: 2
    t.string    "business_mailing_address_telephone_number", limit: 20
    t.string    "business_mailing_address_fax_number",       limit: 20
    t.string    "first_line_location_address",               limit: 55
    t.string    "second_line_location_address",              limit: 55
    t.string    "location_address_city_name",                limit: 40
    t.string    "location_address_state_name",               limit: 40
    t.string    "location_address_postal_code",              limit: 5
    t.string    "location_address_country_code",             limit: 2
    t.string    "location_address_telephone_number",         limit: 20
    t.string    "location_address_fax_number",               limit: 20
    t.date      "enumeration_date"
    t.date      "last_update_date"
    t.string    "npi_deactivation_reason_code",              limit: 2
    t.date      "npi_deactivation_date"
    t.date      "npi_reactivation_date"
    t.string    "gender_code",                               limit: 1
    t.string    "authorized_official_last_name",             limit: 35
    t.string    "authorized_official_first_name",            limit: 20
    t.string    "authorized_official_middle_name",           limit: 20
    t.string    "authorized_official_title_or_position",     limit: 35
    t.string    "authorized_official_telephone_number",      limit: 20
    t.boolean   "is_sole_proprietor"
    t.boolean   "is_organization_subpart"
    t.string    "parent_organization_lbn",                   limit: 70
    t.string    "parent_organization_tin",                   limit: 9
    t.string    "authorized_official_name_prefix_text",      limit: 5
    t.string    "authorized_official_name_suffix_text",      limit: 5
    t.string    "authorized_official_credential_text",       limit: 20
    t.geography "geo",                                       limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.boolean   "is_pharmacy",                                                                                        default: false
    t.datetime  "created_at"
    t.datetime  "updated_at"
  end

  add_index "providers", ["geo"], name: "index_providers_on_geo", using: :gist
  add_index "providers", ["location_address_postal_code"], name: "postal_code", using: :btree
  add_index "providers", ["npi"], name: "index_providers_on_npi", unique: true, using: :btree

  create_table "providers_users", force: :cascade do |t|
    t.integer "provider_id"
    t.integer "user_id"
  end

  add_index "providers_users", ["provider_id"], name: "index_providers_users_on_provider_id", using: :btree
  add_index "providers_users", ["user_id"], name: "index_providers_users_on_user_id", using: :btree

  create_table "pulse_oxygens", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "pulse_oxygen"
    t.string   "units",        default: "SpO2"
    t.datetime "created_at"
  end

  add_index "pulse_oxygens", ["user_id"], name: "index_pulse_oxygens_on_user_id", using: :btree

  create_table "recommended_links", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refill_infos", force: :cascade do |t|
    t.integer  "medication_id"
    t.string   "rx_number"
    t.date     "rx_fill_date"
    t.integer  "refill_num"
    t.integer  "refill_total"
    t.integer  "current_med_count"
    t.integer  "days_supply"
    t.date     "discard_date"
    t.date     "refills_expiration"
    t.datetime "created_at"
    t.boolean  "active_refill",      default: true
  end

  add_index "refill_infos", ["medication_id"], name: "index_refill_infos_on_medication_id", using: :btree

  create_table "reminders", force: :cascade do |t|
    t.integer  "medication_id"
    t.integer  "user_id"
    t.string   "guid"
    t.boolean  "sunday",        default: true
    t.boolean  "monday",        default: true
    t.boolean  "tuesday",       default: true
    t.boolean  "wednesday",     default: true
    t.boolean  "thursday",      default: true
    t.boolean  "friday",        default: true
    t.boolean  "saturday",      default: true
    t.integer  "hour"
    t.integer  "minute"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "deleted"
  end

  add_index "reminders", ["medication_id"], name: "index_reminders_on_medication_id", using: :btree
  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id", using: :btree

  create_table "temperatures", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "temperature"
    t.string   "units",       default: "F"
    t.datetime "created_at"
  end

  add_index "temperatures", ["user_id"], name: "index_temperatures_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",                               null: false
    t.string   "uid",                    default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "is_admin",               default: false
    t.integer  "height"
    t.integer  "weight"
    t.string   "gender"
    t.date     "dob"
    t.text     "tokens"
    t.jsonb    "device_tokens",          default: []
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  create_table "weights", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "weight"
    t.string   "units",      default: "lbs"
    t.datetime "created_at"
  end

  add_index "weights", ["user_id"], name: "index_weights_on_user_id", using: :btree

  add_foreign_key "ndc_packages", "ndc_products", name: "fk_ndc_packages_to_ndc_products"
end
