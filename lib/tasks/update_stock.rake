namespace :stock do
  desc "Update capital increase" 
  task :update_capital_increases => :environment do
    
    @capital_increases = CapitalIncrease.where(:date_issued => Date.today.at_beginning_of_month...Date.today)
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
    
  end
  
end