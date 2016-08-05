class Stock < ActiveRecord::Base
  belongs_to :identity
  has_one :company

  scope :specific_stock, -> (company_id, stock_class, date_issued) { 
    where(company_id: company_id, stock_class: stock_class, date_issued: date_issued)
  }
  
  scope :owned_by, -> (identity_id) { where(identity_id: identity_id) }
  
end
