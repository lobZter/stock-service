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
end
