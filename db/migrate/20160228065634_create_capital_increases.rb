class CreateCapitalIncreases < ActiveRecord::Migration
  def change
    create_table :capital_increases do |t|
      t.integer :company_id, unsigned: true, null: false
      t.string :class, null: false
      t.date :date_issued, null: false
      t.decimal :fund, null: false
      t.integer :currency, unsigned: true, null: false
      t.decimal :stock_price, null: false
      t.decimal :stock_num, null: false
      t.string :remark

      t.timestamps null: false
    end
  end
end
