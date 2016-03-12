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
  
  validate :check_stock_num
  
  
  private
  def check_stock_num
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

end
