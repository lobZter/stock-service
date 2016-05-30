class DeleteStaffInCompany < ActiveRecord::Migration
  def change
    remove_column :companies, :chairman_name
    remove_column :companies, :chairman_passport
    remove_column :companies, :chairman_email
    remove_column :companies, :cfo_name
    remove_column :companies, :cfo_passport
    remove_column :companies, :cfo_email
    remove_column :companies, :ceo_name
    remove_column :companies, :ceo_passport
    remove_column :companies, :ceo_email
    remove_column :companies, :accounting_name
    remove_column :companies, :accounting_passport
    remove_column :companies, :accounting_email
    remove_column :companies, :registered_agent_name
    remove_column :companies, :registered_agent_passport
    remove_column :companies, :registered_agent_email
    
  end
end
