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

ActiveRecord::Schema.define(version: 20160228065653) do

  create_table "capital_increases", force: :cascade do |t|
    t.integer  "company_id",  null: false
    t.string   "class",       null: false
    t.date     "date_issued", null: false
    t.decimal  "fund",        null: false
    t.integer  "currency",    null: false
    t.decimal  "stock_price", null: false
    t.decimal  "stock_num",   null: false
    t.string   "remark"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name_zh",                   null: false
    t.string   "name_en",                   null: false
    t.string   "ein",                       null: false
    t.string   "phone",                     null: false
    t.string   "address",                   null: false
    t.string   "chairman_name",             null: false
    t.string   "chairman_passport",         null: false
    t.string   "chairman_email",            null: false
    t.string   "cfo_name",                  null: false
    t.string   "cfo_passport",              null: false
    t.string   "cfo_email",                 null: false
    t.string   "ceo_name",                  null: false
    t.string   "ceo_passport",              null: false
    t.string   "ceo_email",                 null: false
    t.string   "accounting_name",           null: false
    t.string   "accounting_passport",       null: false
    t.string   "accounting_email",          null: false
    t.string   "registered_agent_name",     null: false
    t.string   "registered_agent_passport", null: false
    t.string   "registered_agent_email",    null: false
    t.string   "us_account_bank",           null: false
    t.string   "us_account_num",            null: false
    t.string   "us_account_name",           null: false
    t.string   "us_account_bank_addr",      null: false
    t.string   "cn_account_bank",           null: false
    t.string   "cn_account_num",            null: false
    t.string   "cn_account_name",           null: false
    t.string   "cn_account_bank_addr",      null: false
    t.string   "tw_account_bank",           null: false
    t.string   "tw_account_num",            null: false
    t.string   "tw_account_name",           null: false
    t.string   "tw_account_bank_addr",      null: false
    t.date     "date_establish",            null: false
    t.date     "date_accounting",           null: false
    t.decimal  "fund",                      null: false
    t.integer  "currency",                  null: false
    t.string   "stock_class",               null: false
    t.decimal  "stock_price",               null: false
    t.decimal  "stock_num",                 null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "stockholders", force: :cascade do |t|
    t.string   "name_zh",          null: false
    t.string   "name_en",          null: false
    t.boolean  "is21",             null: false
    t.string   "representative"
    t.string   "passport",         null: false
    t.string   "country",          null: false
    t.string   "phone",            null: false
    t.string   "wechat",           null: false
    t.string   "address",          null: false
    t.string   "email",            null: false
    t.string   "account_bank",     null: false
    t.string   "account_num",      null: false
    t.string   "account_owner",    null: false
    t.string   "account_owner_id", null: false
    t.string   "copy_passport",    null: false
    t.string   "copy_signature",   null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.integer  "own_id",           null: false
    t.boolean  "own_is_company",   null: false
    t.integer  "stock_company_id", null: false
    t.string   "stock_class",      null: false
    t.decimal  "stock_num",        null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer  "seller_id",         null: false
    t.boolean  "seller_is_company", null: false
    t.integer  "buyer_id",          null: false
    t.boolean  "buyer_is_company",  null: false
    t.integer  "stock_company_id",  null: false
    t.string   "stock_class",       null: false
    t.date     "stock_issued_date", null: false
    t.decimal  "fund",              null: false
    t.integer  "currency",          null: false
    t.date     "date_paid",         null: false
    t.decimal  "stock_price",       null: false
    t.decimal  "stock_num",         null: false
    t.date     "date_signed",       null: false
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
    t.boolean  "contract_0_needed", null: false
    t.boolean  "contract_1_needed", null: false
    t.boolean  "contract_2_needed", null: false
    t.boolean  "contract_3_needed", null: false
    t.boolean  "contract_4_needed", null: false
    t.boolean  "contract_5_needed", null: false
    t.boolean  "contract_6_needed", null: false
    t.boolean  "contract_7_needed", null: false
    t.date     "send_buyer"
    t.date     "send_seller"
    t.string   "remark"
    t.string   "remark_contract"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

end
