class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :seller_id, unsigned: true
      t.boolean :seller_is_company
      t.integer :buyer_id, unsigned: true
      t.boolean :buyer_is_company
      t.integer :stock_company_id, unsigned: true
      t.string :stock_class
      t.date :stock_issued_date
      t.decimal :fund
      t.integer :currency, unsigned: true
      t.date :date_paid
      t.decimal :stock_price
      t.decimal :stock_num
      t.date :date_signed
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
      t.boolean :contract_0_needed
      t.boolean :contract_1_needed
      t.boolean :contract_2_needed
      t.boolean :contract_3_needed
      t.boolean :contract_4_needed
      t.boolean :contract_5_needed
      t.boolean :contract_6_needed
      t.boolean :contract_7_needed
      t.date :send_buyer
      t.date :send_seller
      t.string :remark
      t.string :remark_contract

      t.timestamps null: false
    end
  end
end
