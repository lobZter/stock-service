class Identity < ActiveRecord::Base
  belongs_to :company
  has_many :capital_increases
  belongs_to :stockholder
  has_many :transactions
end
