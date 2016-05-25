class AddNameToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :name, :string
  end
end
