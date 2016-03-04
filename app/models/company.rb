class Company < ActiveRecord::Base
  has_one :identity
  belongs_to :identity
end
