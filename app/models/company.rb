class Company < ActiveRecord::Base
  has_one :identity
  belongs_to :identity
  belongs_to :stocks
  
  validates_presence_of :name_zh, 
    :date_establish,
    :fund,
    :stock_price,
    :stock_class,
    :currency,
    :stock_num
    
  validate :readonly_field, :on => :update

  def readonly_field
    self.errors.add(:identity_id, "identity_id can't be changed") if self.identity_id_changed?
  end
end
