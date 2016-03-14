class Company < ActiveRecord::Base
  has_one :identity
  belongs_to :identity
  belongs_to :stocks
  
  validates_presence_of :name_zh, 
    :date_establish,
    :fund,
    :stock_price,
    :stock_class,
    :currency,
    :stock_num
    
  validate :check_capital_increase, :on => :update
  
  private
  def check_capital_increase
    if self.date_establish_changed? or self.fund_changed? or self.stock_price_changed? or self.stock_class_changed? or self.currency_changed? or self.stock_num_changed?
      
      @capital_increase = CapitalIncrease.where("identity_id=?", self.identity.id)
        .where("remark=?", "起始增資")[0]
        
      if !@capital_increase.stock_checked
        
        capital_increase.destory
        @capital_increase = CapitalIncrease.create(
          :identity_id => self.identity.id,
          :stock_class => self.stock_class,
          :date_issued => self.date_establish,
          :fund => self.fund,
          :currency => self.currency,
          :stock_price => self.stock_price,
          :stock_num => self.stock_num,
          :remark => "起始增資"
        )
        
      else
        
        remaining_stock = Stock.where("company_id=?", self.id)
          .where("stock_class=?", @capital_increase.stock_class)
          .where("date_issued=?", @capital_increase.date_issued)
          .where("identity_id=?", @capital_increase.identity_id)[0]
        
        if !remaining_stock.nil? && remaining_stock.stock_num == @capital_increase.stock_num
          remaining_stock.destory
          capital_increase.destory
          @capital_increase = CapitalIncrease.create(
            :identity_id => self.identity.id,
            :stock_class => self.stock_class,
            :date_issued => self.date_establish,
            :fund => self.fund,
            :currency => self.currency,
            :stock_price => self.stock_price,
            :stock_num => self.stock_num,
            :remark => "起始增資"
          )
        else  
          self.errors.add(:date_establish, "股票已變動, 無法更動起始資金資訊") if self.date_establish_changed?
          self.errors.add(:fund, "股票已變動, 無法更動起始資金資訊") if self.fund_changed?
          self.errors.add(:stock_price, "股票已變動, 無法更動起始資金資訊") if self.stock_price_changed?
          self.errors.add(:stock_class, "股票已變動, 無法更動起始資金資訊") if self.stock_class_changed?
          self.errors.add(:currency, "股票已變動, 無法更動起始資金資訊") if self.currency_changed?
          self.errors.add(:stock_num, "股票已變動, 無法更動起始資金資訊") if self.stock_num_changed?
        end
        
      end
    end
  end
end
