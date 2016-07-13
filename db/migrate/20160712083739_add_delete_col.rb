class AddDeleteCol < ActiveRecord::Migration
  def change
    add_column :companies, :is_deleted, :boolean, :default => false
    add_column :stockholders, :is_deleted, :boolean, :default => false
    add_column :capital_increases, :is_deleted, :boolean, :default => false
    add_column :transactions, :is_deleted, :boolean, :default => false
    drop_table :currencies
  end
end
