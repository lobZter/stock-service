namespace :stock do
  desc "Update capital increase" 
  task :update_capital_increases => :environment do
    
    @capital_increases = CapitalIncrease.where(date_issued => Date.today.at_beginning_of_month...Date.today)
    @capital_increases.each do |c_i|
      if !c_i.stock_checked 
        @stock = Stock.create(:identity_id => c_i.identity_id,
                              :company_id => Identity.find(c_i.identity_id).company_id,
                              :stock_class => c_i.stock_class,
                              :stock_num => c_i.stock_num,
                              :date_issued => c_i.date_issued)
        @c_i = c_i
        @c_i.stock_checked = true
        @c_i.save
      end
    end

  end 
  
  desc "Update transactions"
  task :update_trsacctions => :environment do
    
    @transactions = Transaction.where("date_signed<=?", Date.today)
    
    @transactions.each do |t|
      
      @seller_stock = Stock.where("company_id=?", t.company_id)
        .where("stock_class=?", t.stock_class)
        .where("date_issued=?", t.date_issued)
        .where("identity_id=?", t.seller_id)
      @buyer_stock = Stock.where("company_id=?", t.company_id)
        .where("stock_class=?", t.stock_class)
        .where("date_issued=?", t.date_issued)
        .where("identity_id=?", t.buyer_id)
      
      if !t.stock_checked 
        if @buyer_stock.size == 0
          # create stock for buyer
          @buyer_stock = Stock.create(stock_hash.merge({"identity_id"=>t.buyer_id, "stock_num"=>t.stock_num}))
        else
          # update stock for buyer
          @buyer_stock = @buyer_stock[0]
          stock_num = @buyer_stock.stock_num + t.stock_num
          @buyer_stock.update({"stock_num"=>stock_num})
        end
        if @seller_stock.stock_num - t.stock_num == 0
          # delete stock for seller
          @seller_stock.destroy
        else
          #update stock for seller
          stock_num = @seller_stock.stock_num - t.stock_num
          @seller_stock.update({"stock_num"=>stock_num})
        end
         
      end
    end
    
  end
  
end