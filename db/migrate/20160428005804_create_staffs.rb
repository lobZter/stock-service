class CreateStaffs < ActiveRecord::Migration
  def change
    create_table :staffs do |t|
      t.integer :company_id, unsigned: true
      t.string :job_title
      t.integer :stockholder_id, unsigned: true

      t.timestamps null: false
    end
  end
end
