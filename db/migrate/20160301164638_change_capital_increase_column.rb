class ChangeCapitalIncreaseColumn < ActiveRecord::Migration
  def change
    remove_column :capital_increases, :class
    add_column :capital_increases, :stock_class, :string
  end
end
