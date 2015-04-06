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

ActiveRecord::Schema.define(version: 20150403020936) do

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

  create_table "application_comment_relations", force: true do |t|
    t.integer  "broker_id"
    t.integer  "application_comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "application_comment_relations", ["application_comment_id"], name: "index_application_comment_relations_on_application_comment_id"
  add_index "application_comment_relations", ["broker_id"], name: "index_application_comment_relations_on_broker_id"

  create_table "application_comments", force: true do |t|
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointments", force: true do |t|
    t.integer  "broker_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appointments", ["broker_id", "product_id"], name: "index_appointments_on_broker_id_and_product_id", unique: true
  add_index "appointments", ["broker_id"], name: "index_appointments_on_broker_id"
  add_index "appointments", ["product_id"], name: "index_appointments_on_product_id"

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
    t.string   "gender"
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

  create_table "broker_backups", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "institution_name"
    t.string   "phone_number_work"
    t.string   "email"
    t.string   "phone_number_cell"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "firm_id"
    t.boolean  "change_approved?",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identification_file_name"
    t.string   "identification_content_type"
    t.integer  "identification_file_size"
    t.datetime "identification_updated_at"
    t.integer  "broker_id"
    t.string   "license_type"
  end

  add_index "broker_backups", ["broker_id"], name: "index_broker_backups_on_broker_id"
  add_index "broker_backups", ["firm_id"], name: "index_broker_backups_on_firm_id"

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
    t.boolean  "approved",                    default: false
    t.string   "username"
    t.string   "license_type"
    t.boolean  "submitted",                   default: false
    t.string   "confirmation_number"
    t.datetime "submitted_at"
    t.string   "web"
    t.string   "work_ext"
    t.integer  "firm_id"
    t.string   "register_current_step"
    t.string   "identification_file_name"
    t.string   "identification_content_type"
    t.integer  "identification_file_size"
    t.datetime "identification_updated_at"
    t.string   "status"
    t.string   "auth_token_digest"
    t.string   "edit_current_step"
    t.string   "license_type_edit"
    t.string   "license_type_remove"
  end

  add_index "brokers", ["confirmation_number"], name: "index_brokers_on_confirmation_number"
  add_index "brokers", ["firm_id"], name: "index_brokers_on_firm_id"

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

  create_table "firms", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "web"
    t.string   "business_types"
    t.string   "product_types"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

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
    t.integer  "license_type"
    t.string   "license_number"
    t.boolean  "approved",                         default: false
    t.string   "states"
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

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "product_type"
    t.integer  "firm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["firm_id"], name: "index_products_on_firm_id"

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

  create_table "quote_relations", force: true do |t|
    t.integer  "broker_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "quote_file_file_name"
    t.string   "quote_file_content_type"
    t.integer  "quote_file_file_size"
    t.datetime "quote_file_updated_at"
    t.integer  "product_type"
    t.boolean  "broker_replied?",         default: false
  end

  add_index "quote_relations", ["broker_id"], name: "index_quote_relations_on_broker_id"
  add_index "quote_relations", ["user_id", "broker_id", "product_type"], name: "index_quote_relations", unique: true
  add_index "quote_relations", ["user_id"], name: "index_quote_relations_on_user_id"

  create_table "quote_requirements", force: true do |t|
    t.decimal  "life_insurance_need"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quote_relation_id"
  end

  add_index "quote_requirements", ["quote_relation_id"], name: "index_quote_requirements_on_quote_relation_id"

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

  create_table "schedules", force: true do |t|
    t.integer  "broker_id"
    t.integer  "user_id"
    t.string   "time_begin"
    t.string   "time_end"
    t.decimal  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.date     "schedule_date"
  end

  add_index "schedules", ["broker_id"], name: "index_schedules_on_broker_id"
  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id"

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
    t.integer  "category"
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

  create_table "temp_brokers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "institution_name"
    t.string   "phone_number_work"
    t.string   "email"
    t.string   "phone_number_cell"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "firm_id"
    t.integer  "broker_id"
    t.string   "license_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "change_approved?",            default: false
    t.string   "license_type_edit"
    t.string   "license_type_remove"
    t.integer  "edit_type"
    t.string   "work_ext"
    t.string   "web"
    t.string   "identification_file_name"
    t.string   "identification_content_type"
    t.integer  "identification_file_size"
    t.datetime "identification_updated_at"
  end

  add_index "temp_brokers", ["broker_id"], name: "index_temp_brokers_on_broker_id"

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

  create_table "temp_licenses", force: true do |t|
    t.integer  "temp_broker_id"
    t.integer  "license_type"
    t.string   "license_number"
    t.boolean  "approved",             default: false
    t.string   "states"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "broker_id"
  end

  add_index "temp_licenses", ["broker_id"], name: "index_temp_licenses_on_broker_id"
  add_index "temp_licenses", ["temp_broker_id"], name: "index_temp_licenses_on_temp_broker_id"

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
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "phone_number"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
