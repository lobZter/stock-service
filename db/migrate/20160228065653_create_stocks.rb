class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :own_id, unsigned: true
      t.boolean :own_is_company
      t.integer :stock_company_id, unsigned: true
      t.string :stock_class
      t.decimal :stock_num

      t.timestamps null: false
    end
  end
end
