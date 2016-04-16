class MultipleUpload < ActiveRecord::Migration
  def change
    change_column :transactions, :contract_8, :text
  end
end
