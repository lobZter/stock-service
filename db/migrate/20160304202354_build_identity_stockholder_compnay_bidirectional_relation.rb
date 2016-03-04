class BuildIdentityStockholderCompnayBidirectionalRelation < ActiveRecord::Migration
  def change
    add_column :stockholders, :identity_id, :integer
    add_column :companies, :identity_id, :integer
  end
end
