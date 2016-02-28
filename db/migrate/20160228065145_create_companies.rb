class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name_zh, null: false
      t.string :name_en, null: false
      t.string :ein, null: false
      t.string :phone, null: false
      t.string :address, null: false
      t.string :chairman_name, null: false
      t.string :chairman_passport, null: false
      t.string :chairman_email, null: false
      t.string :cfo_name, null: false
      t.string :cfo_passport, null: false
      t.string :cfo_email, null: false
      t.string :ceo_name, null: false
      t.string :ceo_passport, null: false
      t.string :ceo_email, null: false
      t.string :accounting_name, null: false
      t.string :accounting_passport, null: false
      t.string :accounting_email, null: false
      t.string :registered_agent_name, null: false
      t.string :registered_agent_passport, null: false
      t.string :registered_agent_email, null: false
      t.string :us_account_bank, null: false
      t.string :us_account_num, null: false
      t.string :us_account_name, null: false
      t.string :us_account_bank_addr, null: false
      t.string :cn_account_bank, null: false
      t.string :cn_account_num, null: false
      t.string :cn_account_name, null: false
      t.string :cn_account_bank_addr, null: false
      t.string :tw_account_bank, null: false
      t.string :tw_account_num, null: false
      t.string :tw_account_name, null: false
      t.string :tw_account_bank_addr, null: false
      t.date :date_establish, null: false
      t.date :date_accounting, null: false
      t.decimal :fund, null: false
      t.integer :currency, unsigned: true, null: false
      t.string :stock_class, null: false
      t.decimal :stock_price, null: false
      t.decimal :stock_num, null: false

      t.timestamps null: false
    end
  end
end
