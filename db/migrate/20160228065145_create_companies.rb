class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name_zh
      t.string :name_en
      t.string :ein
      t.string :phone
      t.string :address
      t.string :chairman_name
      t.string :chairman_passport
      t.string :chairman_email
      t.string :cfo_name
      t.string :cfo_passport
      t.string :cfo_email
      t.string :ceo_name
      t.string :ceo_passport
      t.string :ceo_email
      t.string :accounting_name
      t.string :accounting_passport
      t.string :accounting_email
      t.string :registered_agent_name
      t.string :registered_agent_passport
      t.string :registered_agent_email
      t.string :us_account_bank
      t.string :us_account_num
      t.string :us_account_name
      t.string :us_account_bank_addr
      t.string :cn_account_bank
      t.string :cn_account_num
      t.string :cn_account_name
      t.string :cn_account_bank_addr
      t.string :tw_account_bank
      t.string :tw_account_num
      t.string :tw_account_name
      t.string :tw_account_bank_addr
      t.date :date_establish
      t.date :date_accounting
      t.decimal :fund
      t.integer :currency, unsigned: true
      t.string :stock_class
      t.decimal :stock_price
      t.decimal :stock_num

      t.timestamps null: false
    end
  end
end
