class ChangeContract7 < ActiveRecord::Migration
  def change
    remove_column :transactions, :contract_9
    add_column :stockholders, :copy_mail_addr, :string
  end
end
