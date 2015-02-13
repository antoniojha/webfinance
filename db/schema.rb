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

ActiveRecord::Schema.define(version: 20150213045202) do

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

  create_table "backgrounds", force: true do |t|
    t.string   "state"
    t.datetime "dob"
    t.boolean  "married"
    t.integer  "children"
    t.boolean  "has_retirement_plan",    default: false
    t.boolean  "has_emergency_plan",     default: false
    t.boolean  "has_protection_plan",    default: false
    t.boolean  "has_estate_plan",        default: false
    t.boolean  "has_education_plan",     default: false
    t.decimal  "total_optional_expense", default: 0.0
    t.decimal  "total_fixed_expense",    default: 0.0
    t.decimal  "total_income",           default: 0.0
    t.decimal  "total_saving",           default: 0.0
    t.decimal  "total_debt",             default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "current_step"
    t.integer  "year"
    t.integer  "month"
    t.decimal  "networth",               default: 0.0
    t.decimal  "netspend",               default: 0.0
    t.boolean  "completed"
    t.decimal  "total_mortgage",         default: 0.0
    t.decimal  "total_education",        default: 0.0
    t.decimal  "total_protection_need",  default: 0.0
    t.decimal  "other_debt",             default: 0.0
    t.decimal  "income_need",            default: 0.0
    t.string   "protection_search"
    t.decimal  "total_property",         default: 0.0
  end

  add_index "backgrounds", ["user_id"], name: "index_backgrounds_on_user_id"

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

  create_table "broker_imports", force: true do |t|
  end

  create_table "broker_searches", force: true do |t|
    t.string   "name"
    t.string   "license_types"
    t.string   "city"
    t.string   "state"
    t.decimal  "distance_away"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brokers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "institution_name"
    t.string   "phone_number_work"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number_cell"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "approved",                   default: false
    t.string   "username"
    t.string   "license_type"
    t.boolean  "submitted",                  default: false
    t.string   "confirmation_number_digest"
    t.datetime "submitted_at"
    t.string   "web"
    t.string   "work_ext"
  end

  add_index "brokers", ["confirmation_number_digest"], name: "index_brokers_on_confirmation_number_digest"

  create_table "debts", force: true do |t|
    t.string   "institution_name"
    t.string   "description"
    t.decimal  "amount"
    t.decimal  "interest_rate",    default: 0.0
    t.integer  "background_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category"
    t.integer  "fixed_expense_id"
  end

  add_index "debts", ["background_id"], name: "index_debts_on_background_id"

  create_table "education_expenses", force: true do |t|
    t.decimal  "education_cost"
    t.string   "description"
    t.integer  "background_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "age"
  end

  add_index "education_expenses", ["background_id"], name: "index_education_expenses_on_background_id"

  create_table "fixed_expenses", force: true do |t|
    t.string   "description"
    t.string   "company"
    t.decimal  "amount"
    t.datetime "transaction_date"
    t.boolean  "alarm"
    t.integer  "category"
    t.integer  "insurance_category"
    t.integer  "background_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fixed_expenses", ["background_id"], name: "index_fixed_expenses_on_background_id"

  create_table "goals", force: true do |t|
    t.string   "description"
    t.decimal  "amount"
    t.datetime "start_date"
    t.datetime "maturity_date"
    t.boolean  "completed"
    t.integer  "priority"
    t.integer  "background_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goals", ["background_id"], name: "index_goals_on_background_id"

  create_table "incomes", force: true do |t|
    t.string   "description"
    t.decimal  "amount"
    t.integer  "category"
    t.integer  "background_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "incomes", ["background_id"], name: "index_incomes_on_background_id"

  create_table "licenses", force: true do |t|
    t.integer  "broker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "license_type",         limit: 255
    t.string   "license_number"
    t.boolean  "approved",                         default: false
  end

  add_index "licenses", ["broker_id"], name: "index_licenses_on_broker_id"

  create_table "logs", force: true do |t|
    t.string   "endpoint"
    t.string   "method"
    t.text     "params"
    t.integer  "response_code"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "optional_expenses", force: true do |t|
    t.string   "description"
    t.decimal  "amount"
    t.integer  "category"
    t.integer  "background_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "optional_expenses", ["background_id"], name: "index_optional_expenses_on_background_id"

  create_table "plans", force: true do |t|
    t.string   "description"
    t.integer  "category"
    t.datetime "start_date"
    t.datetime "maturity_date"
    t.integer  "year_duration"
    t.decimal  "start_amount"
    t.decimal  "goal_amount"
    t.decimal  "monthly_cost"
    t.decimal  "monthly_return"
    t.decimal  "interest_rate"
    t.integer  "goal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["goal_id"], name: "index_plans_on_goal_id"

  create_table "propertees", force: true do |t|
    t.string   "description"
    t.decimal  "amount"
    t.integer  "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "background_id"
    t.integer  "fixed_expense_id"
  end

  add_index "propertees", ["background_id"], name: "index_propertees_on_background_id"

  create_table "protection_plans", force: true do |t|
    t.decimal  "total_need",    default: 0.0
    t.integer  "start_year"
    t.integer  "start_month"
    t.integer  "end_year"
    t.integer  "end_month"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "background_id"
  end

  add_index "protection_plans", ["background_id"], name: "index_protection_plans_on_background_id"

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

  create_table "savings", force: true do |t|
    t.string   "institution_name"
    t.string   "description"
    t.decimal  "amount"
    t.integer  "category"
    t.integer  "background_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fixed_expense_id"
  end

  add_index "savings", ["background_id"], name: "index_savings_on_background_id"
  add_index "savings", ["plan_id"], name: "index_savings_on_plan_id"

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
    t.integer  "category",             limit: 255
    t.integer  "account_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "spendings", ["account_item_id"], name: "index_spendings_on_account_item_id"
  add_index "spendings", ["user_id"], name: "index_spendings_on_user_id"

  create_table "suggested_goals", force: true do |t|
    t.string   "description"
    t.decimal  "amount"
    t.integer  "category"
    t.datetime "maturity_date"
    t.integer  "background_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suggested_goals", ["background_id"], name: "index_suggested_goals_on_background_id"

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
    t.string   "time_zone"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
