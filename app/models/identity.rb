class Identity < ActiveRecord::Base
  has_one :company
  has_one :stockholder
  belongs_to :company
  belongs_to :stockholder
  
  has_many :capital_increases
  has_many :transactions
end
