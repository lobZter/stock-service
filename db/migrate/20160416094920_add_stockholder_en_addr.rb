class AddStockholderEnAddr < ActiveRecord::Migration
  def change
    add_column :stockholders, :address_en, :string
    rename_column :stockholders, :address, :address_zh
  end
end
