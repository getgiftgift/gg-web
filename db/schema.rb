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

ActiveRecord::Schema.define(version: 20150518223110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "birthday_deal_state_transitions", force: :cascade do |t|
    t.integer  "birthday_deal_id"
    t.string   "namespace"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
  end

  add_index "birthday_deal_state_transitions", ["birthday_deal_id"], name: "index_birthday_deal_state_transitions_on_birthday_deal_id", using: :btree

  create_table "birthday_deal_voucher_state_transitions", force: :cascade do |t|
    t.integer  "birthday_deal_voucher_id"
    t.string   "namespace"
    t.string   "event"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
  end

  add_index "birthday_deal_voucher_state_transitions", ["birthday_deal_voucher_id"], name: "index_transitions_on_voucher_id", using: :btree

  create_table "birthday_deal_vouchers", force: :cascade do |t|
    t.integer  "birthday_deal_id"
    t.integer  "user_id"
    t.string   "verification_number"
    t.date     "valid_on"
    t.date     "good_through"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "birthday_deals", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "value"
    t.string   "hook"
    t.string   "restrictions"
    t.string   "how_to_redeem"
    t.string   "slug"
    t.string   "state"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "location_id"
    t.integer  "occasion_id"
  end

  add_index "birthday_deals", ["occasion_id"], name: "index_birthday_deals_on_occasion_id", using: :btree

  create_table "birthday_deals_company_locations", id: false, force: :cascade do |t|
    t.integer  "birthday_deal_id"
    t.integer  "company_location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "birthday_deals_company_locations", ["birthday_deal_id"], name: "index_birthday_deals_company_locations_on_birthday_deal_id", using: :btree
  add_index "birthday_deals_company_locations", ["company_location_id"], name: "index_birthday_deals_company_locations_on_company_location_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.boolean  "archived"
    t.string   "url"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.string   "facebook_handle"
    t.string   "twitter_handle"
  end

  create_table "company_locations", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "fax"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.integer  "company_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "postal_code"
    t.string   "email"
    t.string   "token"
    t.integer  "company_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
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

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lng"
    t.float    "lat"
  end

  create_table "occasions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  create_table "referrals", force: :cascade do |t|
    t.integer "referrer_id"
    t.integer "recipient_id"
  end

  create_table "restriction_items", force: :cascade do |t|
    t.integer  "birthday_deal_id"
    t.integer  "restriction_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "restrictions", force: :cascade do |t|
    t.string   "category"
    t.string   "phrase"
    t.string   "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.date     "birthdate"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin"
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "gender"
    t.string   "referral_code"
    t.integer  "location_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "birthday_deal_state_transitions", "birthday_deals"
  add_foreign_key "birthday_deal_voucher_state_transitions", "birthday_deal_vouchers"
  add_foreign_key "users", "locations"
end
