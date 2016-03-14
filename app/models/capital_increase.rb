class CapitalIncrease < ActiveRecord::Base
  belongs_to :identity
  
  validates_presence_of :identity_id,
    :stock_class,
    :date_issued,
    :fund,
    :currency,
    :stock_price,
    :stock_num
  
  validates_inclusion_of :stock_checked, :in => [true, false]
  
  validate :check_stock_num, :on => :create
  validate :readonly_field, :on => :update
  
  private
  def check_stock_num
    return if stock_num.nil? or identity_id.nil? or stock_class.nil? or date_issued.nil? or fund.nil? or currency.nil? or stock_price.nil? or stock_num.nil?
    if self.stock_num < 0
      stock = Stock.where("company_id=?", self.identity.company_id)
        .where("stock_class=?", self.stock_class)
        .where("date_issued=?", self.date_issued)
        .where("identity_id=?", self.identity_id)
      if stock.size == 0
        self.errors.add(:stock_class, "減資失敗: 未擁有此股")
      elsif stock[0].stock_num + self.stock_num < 0
        self.errors.add(:stock_num, "減資失敗: 擁有股票數量不足")
      else
        stock[0].stock_num += self.stock_num
        stock[0].save
        self.stock_checked = true
      end
    elsif self.stock_num == 0
      self.errors.add(:stock_num, "增資失敗: 股票數不可為零")
    else
      if self.date_issued <= Date.today
        @stock = Stock.create(:identity_id => self.identity_id,
          :company_id => self.identity.company_id,
          :stock_class => self.stock_class,
          :stock_num => self.stock_num,
          :date_issued => self.date_issued)
        self.stock_checked = true
      end
    end
  end
  
  def readonly_field
    self.errors.add(:identity_id, "identity_id can't be changed") if self.identity_id_changed?
    self.errors.add(:stock_class, "identity_id can't be changed") if self.stock_class_changed?
    self.errors.add(:date_issued, "date_issued can't be changed") if self.date_issued_changed?
    self.errors.add(:fund, "fund can't be changed") if self.fund_changed?
    self.errors.add(:currency, "currency can't be changed") if self.currency_changed?
    self.errors.add(:stock_price, "stock_price can't be changed") if self.stock_price_changed?
    self.errors.add(:stock_num, "stock_num can't be changed") if self.stock_num_changed?
    self.errors.add(:remark, "remark can't be changed") if self.remark_changed?
  end

end
