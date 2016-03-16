class CapitalIncreaseAddCol < ActiveRecord::Migration
  def change
    add_column :capital_increases, :date_decreased, :string
    add_column :capital_increases, :is_first, :boolean
  end
end
