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
  
  private
  def check_stock_num
    seller_stock = Stock.where("company_id=?", self.company_id)
      .where("stock_class=?", self.stock_class)
      .where("date_issued=?", self.date_issued)
      .where("identity_id=?", self.seller_id)
    seller_stock_num = 0
    if seller_stock[0] != nil
      seller_stock_num = seller_stock[0].stock_num
    end
    if self.stock_num != nil && self.stock_num > seller_stock_num
      self.errors.add(:stock_num, "交易股數大於賣方擁有股數")
    end
  end
  
end
