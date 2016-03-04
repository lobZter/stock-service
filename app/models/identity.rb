class Identity < ActiveRecord::Base
  belongs_to :company
  belongs_to :stockholders
  
  has_many :capital_increases
  has_many :transactions
  has_many :stocks
end
