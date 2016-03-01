class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.integer :identity_id, unsigned: true
      t.integer :company_id, unsigned: true
      t.string :stock_class
      t.decimal :stock_num

      t.timestamps null: false
    end
  end
end
