class CISetDefault < ActiveRecord::Migration
  def change
    change_column :capital_increases, :is_first, :boolean, :default => false
    change_column :capital_increases, :stock_checked, :boolean, :default => false
  end
end
