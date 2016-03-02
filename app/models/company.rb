class Company < ActiveRecord::Base
  has_one :identities
end
