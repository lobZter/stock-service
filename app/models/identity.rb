class Identity < ActiveRecord::Base
  belongs_to :company
  has_many :capital_increases
end
