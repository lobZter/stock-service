class Company < ActiveRecord::Base
  has_one :identity
  belongs_to :identity
  belongs_to :stocks
  has_many :staffs
  has_many :capital_increases
  
  validates_presence_of :name_zh, 
    :date_establish,
    :fund,
    :stock_price,
    :stock_class,
    :currency,
    :stock_num
    
  validate :check_capital_increase, :on => :update
  
  scope :deleted, -> { where("is_deleted=?", true)}
  scope :not_deleted, -> { where("is_deleted=?", false)}
  
  def stock_percentage
    @capital_increases = CapitalIncrease.where("identity_id=?", self.identity.id)
    @transactions = Transaction.where("company_id=? AND is_signed=? AND is_lacking=?", self.id, true, false)
    
    @complete_hash = Hash.new
    @complete_hash[@capital_increases[0].identity_id] = Hash.new
    @complete_hash[@capital_increases[0].identity_id][:name_zh] = self.name_zh
    @complete_hash[@capital_increases[0].identity_id][:stock_num] = 0
    @complete_hash[@capital_increases[0].identity_id][:percentage] = 0
    
    @capital_increases.each do |c|
      @complete_hash[c.identity_id][:stock_num] += c.stock_num
    end
    
    total_stock_num = @complete_hash[@capital_increases[0].identity_id][:stock_num]
    
    @transactions.each do |t|
      if not @complete_hash.has_key? t.buyer_id
        @complete_hash[t.buyer_id] = Hash.new
        @complete_hash[t.buyer_id][:name_zh] = Identity.find(t.buyer_id).self_detail.name_zh
        @complete_hash[t.buyer_id][:stock_num] = 0
        @complete_hash[t.buyer_id][:percentage] = 0
      end
      
      if not @complete_hash.has_key? t.seller_id
        @complete_hash[t.seller_id] = Hash.new
        @complete_hash[t.seller_id][:name_zh] = Identity.find(t.seller_id).self_detail.name_zh
        @complete_hash[t.seller_id][:stock_num] = 0
        @complete_hash[t.seller_id][:percentage] = 0
      end
    end
    
    @transactions.each do |t|
      @complete_hash[t.buyer_id][:stock_num] += t.stock_num
      @complete_hash[t.seller_id][:stock_num] -= t.stock_num
    end
    
    @complete_tuple = @complete_hash.values
    @complete_tuple.each do |c|
      c[:percentage] = (c[:stock_num] / total_stock_num).round(5)
    end
    @complete_tuple.sort_by! {|a| -a[:percentage]}
    
  end
  
  private
  def check_capital_increase
    if self.date_establish_changed? or self.fund_changed? or self.stock_price_changed? or self.stock_class_changed? or self.currency_changed? or self.stock_num_changed?
      
      @capital_increase = CapitalIncrease.where("identity_id=?", self.identity.id)
        .where("is_first=?", true)[0]
        
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
          :remark => "起始增資",
          :is_first => true
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
            :remark => "起始增資",
            :is_first => true
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
