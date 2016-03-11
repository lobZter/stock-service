class Company < ActiveRecord::Base
  has_one :identity
  belongs_to :identity
  belongs_to :stocks
  
  validates_presence_of :name_zh, 
    :date_establish,
    :fund,
    :currency,
    :stock_class,
    :stock_num
end
