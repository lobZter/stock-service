class Stock < ActiveRecord::Base
  def self.types
    [["A股", 1], ["B股", 2], ["C股", 3]]
  end
end
