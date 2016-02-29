class CreateCapitalIncreases < ActiveRecord::Migration
  def change
    create_table :capital_increases do |t|
      t.integer :company_id, unsigned: true
      t.string :class
      t.date :date_issued
      t.decimal :fund
      t.integer :currency, unsigned: true
      t.decimal :stock_price
      t.decimal :stock_num
      t.string :remark

      t.timestamps null: false
    end
  end
end
