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

ActiveRecord::Schema.define(version: 20160330060151) do

  create_table "capital_increases", force: :cascade do |t|
    t.integer  "identity_id",    limit: 4
    t.date     "date_issued"
    t.decimal  "fund",                       precision: 65, scale: 6
    t.integer  "currency",       limit: 4
    t.decimal  "stock_price",                precision: 65, scale: 6
    t.decimal  "stock_num",                  precision: 65, scale: 6
    t.string   "remark",         limit: 255
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "stock_class",    limit: 255
    t.boolean  "stock_checked"
    t.string   "date_decreased", limit: 255
    t.boolean  "is_first"
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name_zh",                   limit: 255
    t.string   "name_en",                   limit: 255
    t.string   "ein",                       limit: 255
    t.string   "phone",                     limit: 255
    t.string   "address",                   limit: 255
    t.string   "chairman_name",             limit: 255
    t.string   "chairman_passport",         limit: 255
    t.string   "chairman_email",            limit: 255
    t.string   "cfo_name",                  limit: 255
    t.string   "cfo_passport",              limit: 255
    t.string   "cfo_email",                 limit: 255
    t.string   "ceo_name",                  limit: 255
    t.string   "ceo_passport",              limit: 255
    t.string   "ceo_email",                 limit: 255
    t.string   "accounting_name",           limit: 255
    t.string   "accounting_passport",       limit: 255
    t.string   "accounting_email",          limit: 255
    t.string   "registered_agent_name",     limit: 255
    t.string   "registered_agent_passport", limit: 255
    t.string   "registered_agent_email",    limit: 255
    t.string   "us_account_bank",           limit: 255
    t.string   "us_account_num",            limit: 255
    t.string   "us_account_name",           limit: 255
    t.string   "us_account_bank_addr",      limit: 255
    t.string   "cn_account_bank",           limit: 255
    t.string   "cn_account_num",            limit: 255
    t.string   "cn_account_name",           limit: 255
    t.string   "cn_account_bank_addr",      limit: 255
    t.string   "tw_account_bank",           limit: 255
    t.string   "tw_account_num",            limit: 255
    t.string   "tw_account_name",           limit: 255
    t.string   "tw_account_bank_addr",      limit: 255
    t.date     "date_establish"
    t.date     "date_accounting"
    t.decimal  "fund",                                  precision: 65, scale: 6
    t.integer  "currency",                  limit: 4
    t.string   "stock_class",               limit: 255
    t.decimal  "stock_price",                           precision: 65, scale: 6
    t.decimal  "stock_num",                             precision: 65, scale: 6
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.integer  "identity_id",               limit: 4
  end

  create_table "currencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "stockholder_id", limit: 4
    t.integer  "company_id",     limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "stockholders", force: :cascade do |t|
    t.string   "name_zh",          limit: 255
    t.string   "name_en",          limit: 255
    t.boolean  "is21"
    t.string   "representative",   limit: 255
    t.string   "passport",         limit: 255
    t.string   "country",          limit: 255
    t.string   "phone",            limit: 255
    t.string   "wechat",           limit: 255
    t.string   "address",          limit: 255
    t.string   "email",            limit: 255
    t.string   "account_bank",     limit: 255
    t.string   "account_num",      limit: 255
    t.string   "account_owner",    limit: 255
    t.string   "account_owner_id", limit: 255
    t.string   "copy_passport",    limit: 255
    t.string   "copy_signature",   limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "identity_id",      limit: 4
    t.string   "copy_mail_addr",   limit: 255
  end

  create_table "stocks", force: :cascade do |t|
    t.integer  "identity_id", limit: 4
    t.integer  "company_id",  limit: 4
    t.string   "stock_class", limit: 255
    t.decimal  "stock_num",               precision: 65, scale: 6
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.date     "date_issued"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "seller_id",         limit: 4
    t.integer  "buyer_id",          limit: 4
    t.integer  "company_id",        limit: 4
    t.string   "stock_class",       limit: 255
    t.date     "date_issued"
    t.decimal  "fund",                          precision: 65, scale: 6
    t.integer  "currency",          limit: 4
    t.date     "date_paid"
    t.decimal  "stock_price",                   precision: 65, scale: 6
    t.decimal  "stock_num",                     precision: 65, scale: 6
    t.date     "date_signed"
    t.string   "contract_0",        limit: 255
    t.string   "contract_1",        limit: 255
    t.string   "contract_2",        limit: 255
    t.string   "contract_3",        limit: 255
    t.string   "contract_4",        limit: 255
    t.string   "contract_5",        limit: 255
    t.string   "contract_6",        limit: 255
    t.string   "contract_7",        limit: 255
    t.string   "contract_8",        limit: 255
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
    t.string   "remark",            limit: 255
    t.string   "remark_contract",   limit: 255
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.decimal  "fund_original",                 precision: 65, scale: 6
    t.integer  "currency_original", limit: 4
    t.float    "exchange_rate",     limit: 24
  end

end
