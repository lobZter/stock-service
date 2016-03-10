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

ActiveRecord::Schema.define(version: 20160309041409) do

  create_table "capital_increases", force: :cascade do |t|
    t.integer  "identity_id"
    t.date     "date_issued"
    t.decimal  "fund"
    t.integer  "currency"
    t.decimal  "stock_price"
    t.decimal  "stock_num"
    t.string   "remark"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "stock_class"
    t.boolean  "stock_checked"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name_zh"
    t.string   "name_en"
    t.string   "ein"
    t.string   "phone"
    t.string   "address"
    t.string   "chairman_name"
    t.string   "chairman_passport"
    t.string   "chairman_email"
    t.string   "cfo_name"
    t.string   "cfo_passport"
    t.string   "cfo_email"
    t.string   "ceo_name"
    t.string   "ceo_passport"
    t.string   "ceo_email"
    t.string   "accounting_name"
    t.string   "accounting_passport"
    t.string   "accounting_email"
    t.string   "registered_agent_name"
    t.string   "registered_agent_passport"
    t.string   "registered_agent_email"
    t.string   "us_account_bank"
    t.string   "us_account_num"
    t.string   "us_account_name"
    t.string   "us_account_bank_addr"
    t.string   "cn_account_bank"
    t.string   "cn_account_num"
    t.string   "cn_account_name"
    t.string   "cn_account_bank_addr"
    t.string   "tw_account_bank"
    t.string   "tw_account_num"
    t.string   "tw_account_name"
    t.string   "tw_account_bank_addr"
    t.date     "date_establish"
    t.date     "date_accounting"
    t.decimal  "fund"
    t.integer  "currency"
    t.string   "stock_class"
    t.decimal  "stock_price"
    t.decimal  "stock_num"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "identity_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "stockholder_id"
    t.integer  "company_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "stockholders", force: :cascade do |t|
    t.string   "name_zh"
    t.string   "name_en"
    t.boolean  "is21"
    t.string   "representative"
    t.string   "passport"
    t.string   "country"
    t.string   "phone"
    t.string   "wechat"
    t.string   "address"
    t.string   "email"
    t.string   "account_bank"
    t.string   "account_num"
    t.string   "account_owner"
    t.string   "account_owner_id"
    t.string   "copy_passport"
    t.string   "copy_signature"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "identity_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.integer  "identity_id"
    t.integer  "company_id"
    t.string   "stock_class"
    t.decimal  "stock_num"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.date     "date_issued"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "seller_id"
    t.integer  "buyer_id"
    t.integer  "company_id"
    t.string   "stock_class"
    t.date     "date_issued"
    t.decimal  "fund"
    t.integer  "currency"
    t.date     "date_paid"
    t.decimal  "stock_price"
    t.decimal  "stock_num"
    t.date     "date_signed"
    t.string   "contract_0"
    t.string   "contract_1"
    t.string   "contract_2"
    t.string   "contract_3"
    t.string   "contract_4"
    t.string   "contract_5"
    t.string   "contract_6"
    t.string   "contract_7"
    t.string   "contract_8"
    t.string   "contract_9"
    t.boolean  "contract_0_needed"
    t.boolean  "contract_1_needed"
    t.boolean  "contract_2_needed"
    t.boolean  "contract_3_needed"
    t.boolean  "contract_4_needed"
    t.boolean  "contract_5_needed"
    t.boolean  "contract_6_needed"
    t.boolean  "contract_7_needed"
    t.date     "send_buyer"
    t.date     "send_seller"
    t.string   "remark"
    t.string   "remark_contract"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.decimal  "fund_original"
    t.integer  "currency_original"
    t.float    "exchange_rate"
  end

end
