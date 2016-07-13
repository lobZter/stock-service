class AddDeleteDate < ActiveRecord::Migration
  def change
    add_column :companies, :date_deleted, :datetime
    add_column :stockholders, :date_deleted, :datetime
    add_column :capital_increases, :date_deleted, :datetime
    add_column :transactions, :date_deleted, :datetime
  end
end
