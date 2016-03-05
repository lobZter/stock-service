class Currency < ActiveRecord::Base
  def self.types
    return [["USD", 1], ["RMB", 2], ["NTD", 3]]
  end
end
