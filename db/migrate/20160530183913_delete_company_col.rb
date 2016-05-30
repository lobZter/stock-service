class DeleteCompanyCol < ActiveRecord::Migration
  def change
    remove_column :companies, :company_id
    remove_column :companies, :stockholder_id
    remove_column :companies, :job_title
    remove_column :companies, :name
  end
end
