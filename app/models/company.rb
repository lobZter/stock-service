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
    
  validate :readonly_field, :on => :update
  
  private
  def readonly_field
    self.errors.add(:date_establish, "date_establish can't be changed") if self.date_establish_changed?
    self.errors.add(:fund, "fund can't be changed") if self.fund_changed?
    self.errors.add(:stock_price, "stock_price can't be changed") if self.stock_price_changed?
    self.errors.add(:stock_class, "stock_class can't be changed") if self.stock_class_changed?
    self.errors.add(:currency, "currency can't be changed") if self.currency_changed?
    self.errors.add(:stock_num, "stock_num can't be changed") if self.stock_num_changed?
  end
end
