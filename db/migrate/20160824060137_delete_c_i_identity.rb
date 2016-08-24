class DeleteCIIdentity < ActiveRecord::Migration
  def change
    remove_column :capital_increases, :identity_id
  end
end
