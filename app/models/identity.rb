class Identity < ActiveRecord::Base
  has_one :company
  has_one :stockholder
  belongs_to :company
<<<<<<< HEAD
  belongs_to :stockholders
=======
  belongs_to :stockholder
>>>>>>> ed9b1c6c085112daa1a45dfdf9c02f978a452b59
  
  has_many :capital_increases
  has_many :transactions
  has_many :stocks
end
