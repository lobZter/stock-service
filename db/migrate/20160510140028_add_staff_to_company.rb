class AddStaffToCompany < ActiveRecord::Migration
  def change
   add_column :companies , :company_id , :string
   add_column :companies , :stockholder_id , :string
   add_column :companies , :job_title , :string
   add_column :companies , :name , :string
  end
end
