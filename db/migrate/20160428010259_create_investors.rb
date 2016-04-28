class CreateInvestors < ActiveRecord::Migration
  def change
    create_table :investors do |t|
      t.integer :capital_increase_id, unsigned: true
      t.integer :stockholder_id, unsigned: true
      t.decimal :fund, :precision => 65, :scale => 6
      t.decimal :stock_price, :precision => 65, :scale => 6
      t.decimal :stock_num, :precision => 65, :scale => 6
      t.date :date_issued

      t.timestamps null: false
    end
  end
end
