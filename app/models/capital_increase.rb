class CapitalIncrease < ActiveRecord::Base
  belongs_to :company
  
  validates_presence_of :identity_id,
    :stock_class,
    :date_issued,
    :fund,
    :currency,
    :stock_price,
    :stock_num

  validate :check_stock_num_on_create, :on => :create
  validate :readonly_field, :on => :update
  validate :check_stock_num_on_destory, :on => :destroy
  validate :check_stock_num_on_delete, :on => :update, :if => :is_deleted_changed?
  
  scope :deleted, -> { where("is_deleted=?", true)}
  scope :not_deleted, -> { where("is_deleted=?", false)}
  scope :company, -> (company_id) { where(company_id: company_id) }
  
  
  private
  def check_stock_num_on_create
    return if stock_num.nil? or identity_id.nil? or stock_class.nil? or date_issued.nil? or fund.nil? or currency.nil? or stock_price.nil? or stock_num.nil? or stock_checked.nil? or is_first.nil?
    # 減資
    if self.stock_num < 0
      stock = Stock.where("company_id=?", self.company_id)
        .where("stock_class=?", self.stock_class)
        .where("date_issued=?", self.date_issued)
        .where("identity_id=?", self.company.identity.id)
        .first
      if stock.blank?
        self.errors.add(:stock_class, "減資失敗: 未擁有此股")
      else
        stock_num = stock.stock_num += self.stock_num
        if stock_num < 0
          self.errors.add(:stock_num, "減資失敗: 擁有股票數量不足")
        elsif stock_num > 0
          stock.save
        else  
          stock.destroy
        end
      end
      
    # 增資
    elsif self.stock_num > 0
      capital_increase = CapitalIncrease.where("identity_id=?", self.identity_id)
        .where("stock_class=?", self.stock_class)
        .where("date_issued=?", self.date_issued)
        .first
      
      if capital_increase.blank?
        Stock.create(:identity_id => self.company.identity.id,
          :company_id => self.company_id,
          :stock_class => self.stock_class,
          :stock_num => self.stock_num,
          :date_issued => self.date_issued)
      else
        self.errors.add(:date_issued, "增資失敗: 不可增資同發行日期之股票")
      end
    else
      self.errors.add(:stock_num, "增資失敗: 股票數不可為零")
    end
  end
  
  def check_stock_num_on_destory
    if not self.is_first
      stock = Stock.where("company_id=?", self.identity.company_id)
        .where("stock_class=?", self.stock_class)
        .where("date_issued=?", self.date_issued)
        .where("identity_id=?", self.identity_id)
        .first
      
      # 刪除增資
      if self.stock_num > 0
        if stock.nil || stock.stock_num < self.stock_num
          self.errors.add(:stock_num, "剩餘股票數量不合 無法刪除此筆增資")
        elsif stock.stock_num > self.stock_num
          stock_num = stock.stock_num - self.stock_num
          stock.update({:stock_num => stock_num})
        else
          stock.destroy
        end
      # 刪除減資
      else
        if stock.nil?
          Stock.create({
            :identity_id => self.company.identity.id,
            :company_id => self.company_id,
            :stock_class => self.stock_class,
            :date_issued => self.date_issued,
            :stock_num => -self.stock_num})
        else
          stock_num = stock.stock_num - self.stock_num
          stock.update({:stock_num => stock_num})
        end
      end
    else
      self.errors.add(:is_first, "此筆為起始資本 無法刪除此筆增資")
    end
  end
  
  def check_stock_num_on_delete
    # is_deleted: false => true
    if self.is_deleted
      check_stock_num_on_destory()
    end
  end
  
  def readonly_field
    self.errors.add(:identity_id, "READONLY") if self.identity_id_changed?
    self.errors.add(:stock_class, "READONLY") if self.stock_class_changed?
    self.errors.add(:date_issued, "READONLY") if self.date_issued_changed?
    self.errors.add(:fund, "READONLY") if self.fund_changed?
    self.errors.add(:currency, "READONLY") if self.currency_changed?
    self.errors.add(:stock_price, "READONLY") if self.stock_price_changed?
    self.errors.add(:stock_num, "READONLY") if self.stock_num_changed?
    self.errors.add(:is_first, "READONLY") if self.is_first_changed?
  end

end
