class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.integer :stockholder_id, unsigned: true
      t.integer :company_id, unsigned: true

      t.timestamps null: false
    end
  end
end
