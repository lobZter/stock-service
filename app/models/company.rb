class Company < ActiveRecord::Base
  has_one :identity
  belongs_to :identity
  belongs_to :stocks
end
