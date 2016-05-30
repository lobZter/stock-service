class DeletStaffCol < ActiveRecord::Migration
  def change
    remove_column :staffs, :name
  end
end
