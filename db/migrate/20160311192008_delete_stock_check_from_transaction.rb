class DeleteStockCheckFromTransaction < ActiveRecord::Migration
  def change
    remove_column :transactions, :stock_checked
  end
end
