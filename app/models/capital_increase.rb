class CapitalIncrease < ActiveRecord::Base
  belongs_to :identity
  
  validates_presence_of :identity_id,
    :stock_class,
    :date_issued,
    :fund,
    :currency,
    :stock_price,
    :stock_num,
    :stock_checked
end
