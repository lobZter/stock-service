class TransactionAddCol < ActiveRecord::Migration
  def change
    add_column :transactions, :fund_original, :decimal
    add_column :transactions, :currency_original, :integer, unsigned: true
    add_column :transactions, :exchange_rate, :float
  end
end
