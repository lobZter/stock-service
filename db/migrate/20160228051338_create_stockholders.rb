class CreateStockholders < ActiveRecord::Migration
  def change
    create_table :stockholders do |t|
      t.string :name_zh
      t.string :name_en
      t.boolean :is21 
      t.string :representative
      t.string :passport
      t.string :country
      t.string :phone
      t.string :wechat
      t.string :address
      t.string :email
      t.string :account_bank
      t.string :account_num
      t.string :account_owner
      t.string :account_owner_id
      t.string :copy_passport
      t.string :copy_signature
      
      t.timestamps null: false
    end
  end
end
