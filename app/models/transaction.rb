class Transaction < ActiveRecord::Base
  serialize :contract_8, Array
  
  mount_uploader :contract_0, ContractUploader
  mount_uploader :contract_1, ContractUploader
  mount_uploader :contract_2, ContractUploader
  mount_uploader :contract_3, ContractUploader
  mount_uploader :contract_4, ContractUploader
  mount_uploader :contract_5, ContractUploader
  mount_uploader :contract_6, ContractUploader
  mount_uploader :contract_7, ContractUploader
  mount_uploaders :contract_8, ContractUploader
  
  scope :filter_not_completed, -> { where(
    " ((contract_0_needed = ?) AND (contract_0 IS NULL)) OR
      ((contract_1_needed = ?) AND (contract_1 IS NULL)) OR
      ((contract_2_needed = ?) AND (contract_2 IS NULL)) OR
      ((contract_3_needed = ?) AND (contract_3 IS NULL)) OR
      ((contract_4_needed = ?) AND (contract_4 IS NULL)) OR
      ((contract_5_needed = ?) AND (contract_5 IS NULL)) OR
      ((contract_6_needed = ?) AND (contract_6 IS NULL)) OR
      ((contract_7_needed = ?) AND (contract_7 IS NULL)) OR
      (contract_8 IS NULL) OR
      (send_buyer IS NULL) OR
      (send_seller IS NULL)",
    true, true, true, true, true, true, true, true
  )}
  
  scope :filter_completed, -> { where.not(
    " ((contract_0_needed = ?) AND (contract_0 IS NULL)) OR 
      ((contract_1_needed = ?) AND (contract_1 IS NULL)) OR
      ((contract_2_needed = ?) AND (contract_2 IS NULL)) OR
      ((contract_3_needed = ?) AND (contract_3 IS NULL)) OR
      ((contract_4_needed = ?) AND (contract_4 IS NULL)) OR
      ((contract_5_needed = ?) AND (contract_5 IS NULL)) OR
      ((contract_6_needed = ?) AND (contract_6 IS NULL)) OR
      ((contract_7_needed = ?) AND (contract_7 IS NULL)) OR
      (contract_8 IS NULL) OR
      (send_buyer IS NULL) OR
      (send_seller IS NULL)",
    true, true, true, true, true, true, true, true
  )}
    
  scope :buyer_id, -> (buyer_id) { where(buyer_id: buyer_id) }
  scope :seller_id, -> (seller_id) { where(seller_id: seller_id) }
  scope :stock, -> (company_id, stock_class, date_issued) { 
    where(company_id: company_id, stock_class: stock_class, date_issued: date_issued)
  }
  
  validates_presence_of :seller_id,
    :buyer_id,
    :company_id,
    :stock_class,
    :date_issued,
    :fund,
    :currency,
    :stock_price,
    :stock_num,
    :date_signed
  
  validate :check_stock_num, :on => :create
  validate :check_buyer_seller, :on => :create
  validate :readonly_field, :on => :update
  validate :status

  private
  def check_buyer_seller
    return if seller_id.nil? or buyer_id.nil? or company_id.nil? or stock_class.nil? or date_issued.nil? or fund.nil? or currency.nil? or stock_price.nil? or stock_num.nil? or date_signed.nil?
    if self.buyer_id == self.seller_id
      self.errors.add(:buyer_id, "賣方與買方相同")
      self.errors.add(:seller_id, "賣方與買方相同")
    end
  end
  
  def check_stock_num
    return if seller_id.nil? or buyer_id.nil? or company_id.nil? or stock_class.nil? or date_issued.nil? or fund.nil? or currency.nil? or stock_price.nil? or stock_num.nil? or date_signed.nil?
    seller_stock = Stock.where("company_id=?", self.company_id)
      .where("stock_class=?", self.stock_class)
      .where("date_issued=?", self.date_issued)
      .where("identity_id=?", self.seller_id)[0]
    
    if seller_stock == nil
      self.errors.add(:stock_num, "賣方未擁有此股")
    elsif self.stock_num == 0
      self.errors.add(:stock_num, "交易股數不可為零")
    elsif self.stock_num > seller_stock.stock_num
      self.errors.add(:stock_num, "交易股數大於賣方擁有股數")
    else
      buyer_stock = Stock.where("company_id=?", self.company_id)
        .where("stock_class=?", self.stock_class)
        .where("date_issued=?", self.date_issued)
        .where("identity_id=?", self.buyer_id)[0]
      if buyer_stock == nil
        Stock.create({
          :identity_id => self.buyer_id,
          :company_id => self.company_id,
          :stock_class => self.stock_class,
          :date_issued => self.date_issued,
          :stock_num => self.stock_num})
      else
        stock_num = buyer_stock.stock_num + self.stock_num
        buyer_stock.update({:stock_num => stock_num})
      end
      
      if seller_stock.stock_num - self.stock_num == 0
        seller_stock.destroy
      else
        stock_num = seller_stock.stock_num - self.stock_num
        seller_stock.update({:stock_num => stock_num})
      end
    end
  end

  def readonly_field
    self.errors.add(:seller_id, "seller_id can't be changed") if self.seller_id_changed?
    self.errors.add(:buyer_id, "buyer_id can't be changed") if self.buyer_id_changed?
    self.errors.add(:company_id, "company_id can't be changed") if self.company_id_changed?
    self.errors.add(:stock_class, "stock_class can't be changed") if self.stock_class_changed?
    self.errors.add(:date_issued, "date_issued can't be changed") if self.date_issued_changed?
    self.errors.add(:fund, "fund can't be changed") if self.fund_changed?
    self.errors.add(:currency, "currency can't be changed") if self.currency_changed?
    self.errors.add(:stock_price, "stock_price can't be changed") if self.stock_price_changed?
    self.errors.add(:stock_num, "stock_num can't be changed") if self.stock_num_changed?
    self.errors.add(:date_signed, "date_signed can't be changed") if self.date_signed_changed?
  end
  
  def status
    self.is_signed = true
    self.is_lacking = false
    
    # check is_signed (all contracts, signed_buyer, signed_seller)
    if (self.contract_0_needed && !self.contract_0?) ||
       (self.contract_1_needed && !self.contract_1?) ||
       (self.contract_2_needed && !self.contract_2?) ||
       (self.contract_3_needed && !self.contract_3?) ||
       (self.contract_4_needed && !self.contract_4?) ||
       (self.contract_5_needed && !self.contract_5?) ||
       (self.contract_6_needed && !self.contract_6?) ||
       (self.contract_7_needed && !self.contract_7?) ||
       !self.contract_8?
      self.is_signed = false
    end
    
    if not self.signed_buyer? && self.signed_seller?
      self.is_signed = false
    end
    
    # check is_lacking(stockholder information, send_buyer, send_seller, is_printed)
    seller = Identity.find(self.seller_id).self_detail
    buyer = Identity.find(self.buyer_id).self_detail
    
    if seller.class.name == "Stockholder"
      if not seller.copy_passport? && seller.copy_signature? && seller.copy_mail_addr?
        self.is_lacking = true
      end
    end
    
    if buyer.class.name == "Stockholder"
      if not buyer.copy_passport? && buyer.copy_signature? && buyer.copy_mail_addr?
        self.is_lacking = true
      end
    end
    
    if not self.send_buyer? && send_seller?
      self.is_lacking = true
    end
    
    if not self.is_printed?
      self.is_lacking = true
    end
    
    if not self.date_completed?
      if self.is_signed == true && self.is_lacking == false
        self.date_completed = DateTime.now.to_date
      end
    end
  end

end
