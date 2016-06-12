class ChangeIsCompleteToIsSigned < ActiveRecord::Migration
  def change
    rename_column :transactions, :is_completed, :is_signed
  end
end
