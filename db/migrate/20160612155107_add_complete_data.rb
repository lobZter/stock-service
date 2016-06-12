class AddCompleteData < ActiveRecord::Migration
  def change
    add_column :transactions, :date_completed, :date
  end
end
