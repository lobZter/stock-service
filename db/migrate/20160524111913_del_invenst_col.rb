class DelInvenstCol < ActiveRecord::Migration
  def change
    remove_column :investors, :date_issued
  end
end
