class AddTransactionComplete < ActiveRecord::Migration
  def change
    add_column :transactions, :is_completed, :boolean
    add_column :transactions, :is_printed, :boolean
    add_column :transactions, :is_lacking, :boolean
    add_column :transactions, :signed_buyer, :date
    add_column :transactions, :signed_seller, :date
  end
end
