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
    
  validate :readonly_field, :on => :update
  validate :check_on_delete, :on => :update, :if => :is_deleted_changed?
  
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
  def readonly_field
    self.errors.add(:fund, "READONLY") if self.fund_changed?
    self.errors.add(:currency, "READONLY") if self.currency_changed?
    self.errors.add(:stock_class, "READONLY") if self.stock_class_changed?
    self.errors.add(:stock_price, "READONLY") if self.stock_price_changed?
    self.errors.add(:stock_num, "READONLY") if self.stock_num_changed?
  end
  
  def check_on_delete
    capital_increases = CapitalIncrease.where("company_id=?", self.id)
    
    capital_increases.each do |c|
      c.update({is_deleted: true, date_deleted: DateTime.now.to_date})
    end
    
  end
  
end
