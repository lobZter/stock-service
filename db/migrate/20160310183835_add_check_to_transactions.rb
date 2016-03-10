class AddCheckToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :stock_checked, :boolean
  end
end
