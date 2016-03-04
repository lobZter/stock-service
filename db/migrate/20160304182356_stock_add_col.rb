class StockAddCol < ActiveRecord::Migration
  def change
    add_column :stocks, :date_issued, :date
  end
end
