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

ActiveRecord::Schema.define(version: 20150402014712) do

  create_table "birthday_deal_vouchers", force: :cascade do |t|
    t.integer  "birthday_deal_id",    limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "verification_number", limit: 255
    t.date     "valid_on"
    t.date     "good_through"
    t.string   "state",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "birthday_deals", force: :cascade do |t|
    t.integer  "company_id",    limit: 4
    t.integer  "value",         limit: 4
    t.string   "hook",          limit: 255
    t.string   "restrictions",  limit: 255
    t.string   "how_to_redeem", limit: 255
    t.string   "slug",          limit: 255
    t.string   "state",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "location_id",   limit: 4
  end

  create_table "birthday_deals_company_locations", id: false, force: :cascade do |t|
    t.integer  "birthday_deal_id",    limit: 4
    t.integer  "company_location_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "birthday_deals_company_locations", ["birthday_deal_id"], name: "index_birthday_deals_company_locations_on_birthday_deal_id", using: :btree
  add_index "birthday_deals_company_locations", ["company_location_id"], name: "index_birthday_deals_company_locations_on_company_location_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "phone",       limit: 255
    t.string   "street1",     limit: 255
    t.string   "street2",     limit: 255
    t.string   "city",        limit: 255
    t.string   "state",       limit: 255
    t.string   "postal_code", limit: 255
    t.boolean  "archived",    limit: 1
    t.string   "url",         limit: 255
    t.string   "image",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id", limit: 4
  end

  create_table "company_locations", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "phone",       limit: 255
    t.string   "fax",         limit: 255
    t.string   "street1",     limit: 255
    t.string   "street2",     limit: 255
    t.string   "city",        limit: 255
    t.string   "state",       limit: 255
    t.string   "postal_code", limit: 255
    t.integer  "company_id",  limit: 4
    t.integer  "location_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0
    t.integer  "attempts",   limit: 4,     default: 0
    t.text     "handler",    limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "city",       limit: 255
    t.string   "state",      limit: 255
    t.string   "lat",        limit: 255
    t.string   "lng",        limit: 255
    t.string   "slug",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "referrals", force: :cascade do |t|
    t.integer "referrer_id",  limit: 4
    t.integer "recipient_id", limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "email",                  limit: 255
    t.date     "birthdate"
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.boolean  "admin",                  limit: 1
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "oauth_token",            limit: 255
    t.datetime "oauth_expires_at"
    t.string   "gender",                 limit: 255
    t.string   "referral_code",          limit: 255
    t.integer  "location_id",            limit: 4
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "users", "locations"
end
