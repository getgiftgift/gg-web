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

ActiveRecord::Schema.define(version: 20190416002402) do

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
    t.string   "verification_number"
    t.date     "valid_on"
    t.date     "good_through"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "birthday_party_id",                   null: false
    t.boolean  "redeemable",          default: false
  end

  add_index "birthday_deal_vouchers", ["birthday_party_id"], name: "index_birthday_deal_vouchers_on_birthday_party_id", using: :btree

  create_table "birthday_deals", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "hook"
    t.string   "restrictions"
    t.string   "how_to_redeem"
    t.string   "slug"
    t.string   "state"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "location_id"
    t.integer  "occasion_id"
    t.integer  "value_cents",           default: 0,     null: false
    t.string   "value_currency",        default: "USD", null: false
    t.integer  "transaction_fee_cents", default: 99,    null: false
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

  create_table "birthday_parties", force: :cascade do |t|
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "user_id",                              null: false
    t.date     "start_date",                           null: false
    t.integer  "cost_cents",    default: 3000,         null: false
    t.string   "cost_currency", default: "USD",        null: false
    t.date     "end_date",      default: '2017-01-26', null: false
    t.integer  "location_id"
  end

  add_index "birthday_parties", ["location_id"], name: "index_birthday_parties_on_location_id", using: :btree
  add_index "birthday_parties", ["user_id", "start_date"], name: "index_birthday_parties_on_user_id_and_start_date", unique: true, using: :btree
  add_index "birthday_parties", ["user_id"], name: "index_birthday_parties_on_user_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.boolean  "archived"
    t.string   "website"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.string   "facebook_handle"
    t.string   "twitter_handle"
    t.string   "pin"
    t.string   "yelp_id"
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
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "cc_last_four"
    t.string   "cc_card_type"
    t.string   "cc_expiration_month"
    t.string   "cc_expiration_year"
    t.string   "gateway_customer_id"
    t.string   "cardholder_name"
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
    t.string   "lat"
    t.string   "lng"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "sponsorships", force: :cascade do |t|
    t.string   "name",                                      null: false
    t.string   "note"
    t.integer  "amount_per_party_cents",    default: 0,     null: false
    t.string   "amount_per_party_currency", default: "USD", null: false
    t.datetime "start_date",                                null: false
    t.datetime "end_date",                                  null: false
    t.integer  "total_amount_cents",        default: 0,     null: false
    t.string   "total_amount_currency",     default: "USD", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "state"
    t.datetime "subscribed_at"
    t.datetime "unsubscribed_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "birthday_party_id"
    t.string   "transaction_id"
    t.datetime "settled_at"
    t.string   "processor"
    t.integer  "amount_cents",      default: 0,           null: false
    t.string   "amount_currency",   default: "USD",       null: false
    t.string   "name",              default: "Anonymous"
    t.string   "note"
    t.string   "last_4"
    t.string   "card_type"
    t.string   "expiration_date"
    t.string   "cardholder_name"
    t.integer  "sponsorship_id"
    t.string   "type"
    t.string   "status"
  end

  add_index "transactions", ["birthday_party_id"], name: "index_transactions_on_birthday_party_id", using: :btree
  add_index "transactions", ["type", "sponsorship_id"], name: "index_transactions_on_type_and_sponsorship_id", using: :btree

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
    t.string   "payment_token"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "birthday_deal_state_transitions", "birthday_deals"
  add_foreign_key "birthday_deal_voucher_state_transitions", "birthday_deal_vouchers"
  add_foreign_key "birthday_deal_vouchers", "birthday_parties"
  add_foreign_key "birthday_parties", "locations"
  add_foreign_key "transactions", "birthday_parties"
  add_foreign_key "users", "locations"
end
