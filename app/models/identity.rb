class Identity < ActiveRecord::Base
  belongs_to :companies
  has_many :capital_increases
end
