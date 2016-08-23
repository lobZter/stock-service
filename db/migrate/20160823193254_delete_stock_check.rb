class DeleteStockCheck < ActiveRecord::Migration
  def change
    remove_column :capital_increases, :stock_checked
  end
end
