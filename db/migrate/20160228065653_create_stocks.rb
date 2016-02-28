class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :own_id, unsigned: true, null: false
      t.boolean :own_is_company, null: false
      t.integer :stock_company_id, unsigned: true, null: false
      t.string :stock_class, null: false
      t.decimal :stock_num, null: false

      t.timestamps null: false
    end
  end
end
