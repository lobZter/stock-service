class CreateStockholders < ActiveRecord::Migration
  def change
    create_table :stockholders do |t|
      t.string :name_zh,           null: false
      t.string :name_en,           null: false
      t.boolean :is21,             null: false
      t.string :representative
      t.string :passport,          null: false
      t.string :country,           null: false
      t.string :phone,             null: false
      t.string :wechat,            null: false
      t.string :address,           null: false
      t.string :email,             null: false
      t.string :account_bank,      null: false
      t.string :account_num,       null: false
      t.string :account_owner,     null: false
      t.string :account_owner_id,  null: false
      t.string :copy_passport,     null: false
      t.string :copy_signature,    null: false
      
      t.timestamps null: false
    end
  end
end
