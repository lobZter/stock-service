class ResetContract8 < ActiveRecord::Migration
  def change
    remove_column :transactions, :contract_8
    add_column :transactions, :contract_8, :text
  end
end
