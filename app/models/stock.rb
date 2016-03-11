class Stock < ActiveRecord::Base
  belongs_to :identity
  has_one :company

end
