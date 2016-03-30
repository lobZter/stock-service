class EditDecimal < ActiveRecord::Migration
  def up
    change_column :capital_increases, :fund, :decimal, :precision => 65, :scale => 6
    change_column :capital_increases, :stock_price, :decimal, :precision => 65, :scale => 6
    change_column :capital_increases, :stock_num, :decimal, :precision => 65, :scale => 6
    change_column :companies, :fund, :decimal, :precision => 65, :scale => 6
    change_column :companies, :stock_price, :decimal, :precision => 65, :scale => 6
    change_column :companies, :stock_num, :decimal, :precision => 65, :scale => 6
    change_column :stocks, :stock_num, :decimal, :precision => 65, :scale => 6
    change_column :transactions, :fund, :decimal, :precision => 65, :scale => 6
    change_column :transactions, :stock_price, :decimal, :precision => 65, :scale => 6
    change_column :transactions, :stock_num, :decimal, :precision => 65, :scale => 6
    change_column :transactions, :fund_original, :decimal, :precision => 65, :scale => 6
  end

  def down
    change_column :capital_increases, :fund, :decimal
    change_column :capital_increases, :stock_price, :decimal
    change_column :capital_increases, :stock_num, :decimal
    change_column :companies, :fund, :decimal
    change_column :companies, :stock_price, :decimal
    change_column :companies, :stock_num, :decimal
    change_column :stocks, :stock_num, :decimal
    change_column :transactions, :fund, :decimal
    change_column :transactions, :stock_price, :decimal
    change_column :transactions, :stock_num, :decimal
    change_column :transactions, :fund_original, :decimal
  end
end
