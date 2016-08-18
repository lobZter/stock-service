class ChangeCIForeignKey < ActiveRecord::Migration
  def change
    add_column :capital_increases, :company_id, :integer
  end
end
