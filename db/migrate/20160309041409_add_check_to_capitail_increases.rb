class AddCheckToCapitailIncreases < ActiveRecord::Migration
  def change
     add_column :capital_increases, :stock_checked, :boolean
  end
end
