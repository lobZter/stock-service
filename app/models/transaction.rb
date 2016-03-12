class Transaction < ActiveRecord::Base
  
  mount_uploader :contract_0, ContractUploader
  mount_uploader :contract_1, ContractUploader
  mount_uploader :contract_2, ContractUploader
  mount_uploader :contract_3, ContractUploader
  mount_uploader :contract_4, ContractUploader
  mount_uploader :contract_5, ContractUploader
  mount_uploader :contract_6, ContractUploader
  mount_uploader :contract_7, ContractUploader
  mount_uploader :contract_8, ContractUploader
  mount_uploader :contract_9, ContractUploader
  
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
  
  validate :check_stock_num
  
  scope :filter_not_completed, -> { where(
    " ((contract_0_needed = ?) AND (contract_0 IS NULL)) OR
      ((contract_1_needed = ?) AND (contract_1 IS NULL)) OR
      ((contract_2_needed = ?) AND (contract_2 IS NULL)) OR
      ((contract_3_needed = ?) AND (contract_3 IS NULL)) OR
      ((contract_4_needed = ?) AND (contract_4 IS NULL)) OR
      ((contract_5_needed = ?) AND (contract_5 IS NULL)) OR
      ((contract_6_needed = ?) AND (contract_6 IS NULL)) OR
      ((contract_7_needed = ?) AND (contract_7 IS NULL))",
    true, true, true, true, true, true, true, true)}
  
  scope :filter_completed, -> { where.not(
    " ((contract_0_needed = ?) AND (contract_0 IS NULL)) OR 
      ((contract_1_needed = ?) AND (contract_1 IS NULL)) OR
      ((contract_2_needed = ?) AND (contract_2 IS NULL)) OR
      ((contract_3_needed = ?) AND (contract_3 IS NULL)) OR
      ((contract_4_needed = ?) AND (contract_4 IS NULL)) OR
      ((contract_5_needed = ?) AND (contract_5 IS NULL)) OR
      ((contract_6_needed = ?) AND (contract_6 IS NULL)) OR
      ((contract_7_needed = ?) AND (contract_7 IS NULL))",
    true, true, true, true, true, true, true, true)}
  
  private
  def check_stock_num
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
        buyer_stock = Stock.create({
          "identity_id"=>self.buyer_id,
          "company_id"=>self.company_id,
          "stock_class"=>self.stock_class,
          "date_issued"=>self.date_issued,
          "stock_num"=>self.stock_num})
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

end
