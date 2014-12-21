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

ActiveRecord::Schema.define(version: 20141221124636) do

  create_table "account_items", force: true do |t|
    t.integer  "account_id"
    t.integer  "item_account_id"
    t.string   "account_display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "acct_type"
    t.integer  "account_number"
  end

  add_index "account_items", ["account_id"], name: "index_account_items_on_account_id"

  create_table "accounts", force: true do |t|
    t.integer  "user_id"
    t.integer  "bank_id"
    t.integer  "yodlee_id"
    t.integer  "status_code",  default: 801
    t.datetime "last_refresh"
    t.text     "last_mfa"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["bank_id"], name: "index_accounts_on_bank_id"
  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id"

  create_table "advance_searches", force: true do |t|
    t.string   "keyword"
    t.datetime "start_date"
    t.datetime "end_date"
    t.float    "minimum_price"
    t.float    "maximum_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hidden_value"
  end

  create_table "banks", force: true do |t|
    t.integer  "content_service_id"
    t.string   "content_service_display_name"
    t.integer  "site_id"
    t.string   "site_display_name"
    t.string   "mfa"
    t.string   "home_url"
    t.string   "container"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", force: true do |t|
    t.string   "endpoint"
    t.string   "method"
    t.text     "params"
    t.integer  "response_code"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recur_budgets", force: true do |t|
    t.string   "title"
    t.decimal  "price"
    t.datetime "recur_deduction_date"
    t.string   "category"
    t.integer  "temp_budget_plan_id"
    t.boolean  "begin_or_end_of_month"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spendings", force: true do |t|
    t.datetime "transaction_date"
    t.text     "description"
    t.decimal  "amount"
    t.decimal  "balance"
    t.string   "image_url"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "category"
    t.integer  "account_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "spendings", ["account_item_id"], name: "index_spendings_on_account_item_id"

  create_table "temp_budget_plans", force: true do |t|
    t.decimal  "budget_amount",        precision: 8, scale: 2
    t.datetime "deadline"
    t.integer  "recur_period"
    t.decimal  "food_budget",          precision: 8, scale: 2
    t.decimal  "finance_budget",       precision: 8, scale: 2
    t.decimal  "shopping_budget",      precision: 8, scale: 2
    t.decimal  "auto_budget",          precision: 8, scale: 2
    t.decimal  "entertainment_budget", precision: 8, scale: 2
    t.decimal  "other_budget",         precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "finished"
    t.integer  "alert_send_period"
    t.integer  "user_id"
  end

  create_table "transaction_imports", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "email_authen"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token_digest"
    t.string   "email_confirmation_token"
    t.datetime "email_confirmation_sent_at"
    t.string   "yodlee_username"
    t.string   "yodlee_password"
    t.boolean  "budget_cat"
    t.boolean  "accounts_cat"
    t.boolean  "alarm_cat"
    t.boolean  "social_cat"
    t.boolean  "planning_cat"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin",                      default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
