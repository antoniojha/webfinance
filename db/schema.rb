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

ActiveRecord::Schema.define(version: 20150906121756) do

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

  create_table "activities", force: true do |t|
    t.integer  "author_id"
    t.string   "author_type"
    t.string   "action"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "story_owner_id"
    t.string   "story_owner_type"
  end

  add_index "activities", ["author_id"], name: "index_activities_on_author_id"
  add_index "activities", ["story_owner_id"], name: "index_activities_on_story_owner_id"
  add_index "activities", ["trackable_id"], name: "index_activities_on_trackable_id"

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

  create_table "advice_categories", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "advices", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "question_id"
    t.integer  "broker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "advice_category_id"
  end

  add_index "advices", ["advice_category_id"], name: "index_advices_on_advice_category_id"
  add_index "advices", ["broker_id"], name: "index_advices_on_broker_id"
  add_index "advices", ["question_id"], name: "index_advices_on_question_id"

  create_table "all_customers", force: true do |t|
    t.integer  "customer_id"
    t.string   "customer_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "all_customers", ["customer_id"], name: "index_all_customers_on_customer_id"

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

  create_table "broker_product_rels", force: true do |t|
    t.integer  "broker_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "broker_product_rels", ["broker_id"], name: "index_broker_product_rels_on_broker_id"
  add_index "broker_product_rels", ["product_id"], name: "index_broker_product_rels_on_product_id"

  create_table "broker_requests", force: true do |t|
    t.string   "request_type"
    t.integer  "broker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complement"
    t.text     "comment"
    t.string   "admin_reply"
    t.integer  "license_id"
  end

  add_index "broker_requests", ["broker_id"], name: "index_broker_requests_on_broker_id"

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
    t.string   "time_zone"
    t.string   "provider"
    t.string   "uid"
    t.boolean  "email_authen"
    t.string   "email_confirmation_token"
    t.string   "email_confirmation_sent_at"
    t.string   "salt"
    t.string   "title"
    t.string   "step"
    t.boolean  "setup_completed?"
    t.string   "company_name"
    t.string   "company_location"
    t.text     "product_ids"
    t.text     "skills"
    t.text     "ad_statement"
    t.boolean  "check_term_of_use"
    t.string   "image"
    t.string   "aws_image_path"
    t.boolean  "image_cropped"
  end

  add_index "brokers", ["confirmation_number"], name: "index_brokers_on_confirmation_number"
  add_index "brokers", ["firm_id"], name: "index_brokers_on_firm_id"

  create_table "companies", force: true do |t|
    t.text     "description"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "contacts", force: true do |t|
    t.string   "subject"
    t.text     "message"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

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

  create_table "educations", force: true do |t|
    t.string   "school"
    t.string   "degree"
    t.date     "begin_date"
    t.date     "end_date"
    t.text     "description"
    t.string   "honors"
    t.integer  "broker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "educations", ["broker_id"], name: "index_educations_on_broker_id"

  create_table "experiences", force: true do |t|
    t.string   "title"
    t.string   "company"
    t.string   "location"
    t.text     "description"
    t.date     "begin_date"
    t.date     "end_date"
    t.integer  "broker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "current_experience", default: false
  end

  add_index "experiences", ["broker_id"], name: "index_experiences_on_broker_id"

  create_table "financial_goal_story_rels", force: true do |t|
    t.integer  "goal_id"
    t.integer  "financial_story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "summary"
  end

  add_index "financial_goal_story_rels", ["financial_story_id"], name: "index_financial_goal_story_rels_on_financial_story_id"
  add_index "financial_goal_story_rels", ["goal_id"], name: "index_financial_goal_story_rels_on_goal_id"

  create_table "financial_product_rels", force: true do |t|
    t.integer  "financial_product_id"
    t.integer  "broker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "financial_product_rels", ["broker_id"], name: "index_financial_product_rels_on_broker_id"
  add_index "financial_product_rels", ["financial_product_id"], name: "index_financial_product_rels_on_financial_product_id"

  create_table "financial_products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  add_index "financial_products", ["company_id"], name: "index_financial_products_on_company_id"

  create_table "financial_stories", force: true do |t|
    t.integer  "product_id"
    t.integer  "broker_id"
    t.string   "financial_category"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "votes",              default: 0
    t.string   "title"
  end

  add_index "financial_stories", ["broker_id"], name: "index_financial_stories_on_broker_id"
  add_index "financial_stories", ["product_id"], name: "index_financial_stories_on_product_id"

  create_table "financial_testimonies", force: true do |t|
    t.integer  "user_id"
    t.string   "financial_category"
    t.text     "description"
    t.integer  "votes",              default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "product_id"
  end

  add_index "financial_testimonies", ["product_id"], name: "index_financial_testimonies_on_product_id"
  add_index "financial_testimonies", ["user_id"], name: "index_financial_testimonies_on_user_id"

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
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "financial_interests"
  end

  create_table "identities", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "license_type"
    t.string   "license_number"
    t.boolean  "approved",             default: false
    t.string   "states"
    t.integer  "setup_broker_id"
  end

  add_index "licenses", ["broker_id"], name: "index_licenses_on_broker_id"
  add_index "licenses", ["setup_broker_id"], name: "index_licenses_on_setup_broker_id"

  create_table "logs", force: true do |t|
    t.string   "endpoint"
    t.string   "method"
    t.text     "params"
    t.integer  "response_code"
    t.text     "response"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "micro_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "broker_id"
    t.integer  "financial_story_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "financial_testimony_id"
  end

  add_index "micro_comments", ["broker_id"], name: "index_micro_comments_on_broker_id"
  add_index "micro_comments", ["financial_story_id"], name: "index_micro_comments_on_financial_story_id"
  add_index "micro_comments", ["financial_testimony_id"], name: "index_micro_comments_on_financial_testimony_id"
  add_index "micro_comments", ["user_id"], name: "index_micro_comments_on_user_id"

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

  create_table "private_messages", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.integer  "all_customer_id"
    t.integer  "receiver_customer_id"
    t.integer  "followed_message_id"
    t.string   "location"
    t.string   "sender_name"
    t.string   "receiver_name"
    t.string   "sent_or_received"
    t.boolean  "replied",              default: false
    t.integer  "original_message_id"
    t.string   "user_or_broker"
  end

  add_index "private_messages", ["all_customer_id"], name: "index_private_messages_on_all_customer_id"

  create_table "product_fin_category_rels", force: true do |t|
    t.string   "vehicle_type"
    t.integer  "product_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_fin_category_rels", ["product_id", "vehicle_type"], name: "index_product_fin_category_rels_on_product_id_and_vehicle_type", unique: true
  add_index "product_fin_category_rels", ["product_id"], name: "index_product_fin_category_rels_on_product_id"

  create_table "product_questions", force: true do |t|
    t.integer  "product_fin_category_rel_id"
    t.integer  "user_id"
    t.integer  "broker_id"
    t.text     "content"
    t.integer  "vote_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_questions", ["broker_id"], name: "index_product_questions_on_broker_id"
  add_index "product_questions", ["product_fin_category_rel_id"], name: "index_product_questions_on_product_fin_category_rel_id"
  add_index "product_questions", ["user_id"], name: "index_product_questions_on_user_id"

  create_table "products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "vehicle_type"
    t.integer  "firm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "risk_level"
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
    t.datetime "time_begin",    limit: 255
    t.datetime "time_end",      limit: 255
    t.decimal  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.date     "schedule_date"
    t.string   "time_zone"
  end

  add_index "schedules", ["broker_id"], name: "index_schedules_on_broker_id"
  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id"

  create_table "setup_brokers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "broker_id"
  end

  add_index "setup_brokers", ["broker_id"], name: "index_setup_brokers_on_broker_id"

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

  create_table "user_searches", force: true do |t|
    t.string   "name"
    t.string   "state"
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
    t.string   "provider"
    t.string   "uid"
    t.string   "salt"
    t.string   "step"
    t.string   "interests"
    t.string   "income_level"
    t.boolean  "setup_completed?"
    t.string   "occupation"
    t.string   "age_level"
    t.string   "image"
    t.string   "key"
    t.boolean  "image_cropped"
    t.text     "about_statement"
    t.string   "satisfaction"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "votes", force: true do |t|
    t.integer  "financial_story_id"
    t.integer  "user_id"
    t.integer  "broker_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "financial_testimony_id"
  end

  add_index "votes", ["broker_id"], name: "index_votes_on_broker_id"
  add_index "votes", ["financial_story_id"], name: "index_votes_on_financial_story_id"
  add_index "votes", ["financial_testimony_id"], name: "index_votes_on_financial_testimony_id"
  add_index "votes", ["user_id"], name: "index_votes_on_user_id"

end
