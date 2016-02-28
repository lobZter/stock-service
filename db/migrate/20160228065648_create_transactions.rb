class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :seller_id, unsigned: true, null: false
      t.boolean :seller_is_company, null: false
      t.integer :buyer_id, unsigned: true, null: false
      t.boolean :buyer_is_company, null: false
      t.integer :stock_company_id, unsigned: true, null: false
      t.string :stock_class, null: false
      t.date :stock_issued_date, null: false
      t.decimal :fund, null: false
      t.integer :currency, unsigned: true, null: false
      t.date :date_paid, null: false
      t.decimal :stock_price, null: false
      t.decimal :stock_num, null: false
      t.date :date_signed, null: false
      t.string :contract_0
      t.string :contract_1
      t.string :contract_2
      t.string :contract_3
      t.string :contract_4
      t.string :contract_5
      t.string :contract_6
      t.string :contract_7
      t.string :contract_8
      t.string :contract_9
      t.boolean :contract_0_needed, null: false
      t.boolean :contract_1_needed, null: false
      t.boolean :contract_2_needed, null: false
      t.boolean :contract_3_needed, null: false
      t.boolean :contract_4_needed, null: false
      t.boolean :contract_5_needed, null: false
      t.boolean :contract_6_needed, null: false
      t.boolean :contract_7_needed, null: false
      t.date :send_buyer
      t.date :send_seller
      t.string :remark
      t.string :remark_contract

      t.timestamps null: false
    end
  end
end
