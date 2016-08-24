class Identity < ActiveRecord::Base
  has_one :company
  has_one :stockholder
  belongs_to :company
  belongs_to :stockholder
  
  has_many :capital_increases
  has_many :stocks
  
  def self_detail
    if self.stockholder_id == nil
      @company = Company.find(self.company_id)
      return @company  
    elsif self.company_id == nil
      @stockholder = Stockholder.find(self.stockholder_id)
      return @stockholder
    else
      return nil
    end
  end
  
  def stock_detail
    @stocks = self.stocks
    
    stock_array = Array.new
    @stocks.each do |s|
      stock_array.push({
        :id => s.id,
        :identity_id => s.identity_id,
        :company_id => s.company_id,
        :company_name => Company.find(s.company_id).name_zh,
        :currency => Company.find(s.company_id).currency,
        :stock_class => s.stock_class,
        :date_issued => s.date_issued,
        :stock_num => s.stock_num })
    end
    return stock_array
  end
  
  def stock_show
    @stocks = self.stocks.sort_by{|s| s[:updated_at]}.reverse
    
    stock_info_array = Array.new
    stock_num_array = Array.new
    @stocks.each do |s|
      stock_hash= Hash.new
      stock_hash[:company_id] = s.company_id
      stock_hash[:company_name] = Company.find(s.company_id).name_zh
      stock_hash[:stock_class] = s.stock_class
      index = stock_info_array.index(stock_hash)
      if index == nil
        stock_info_array.push(stock_hash)
        stock_num_array.push(s.stock_num)
      else
        stock_num_array[index] += s.stock_num
      end
    end
    return {:stock_info => stock_info_array, :stock_num => stock_num_array}
  end
  
  def recent_transactions
    @transactions = Transaction.where("buyer_id=?", self.id)
    @transactions += Transaction.where("seller_id=?", self.id)
    @transactions = @transactions.sort_by{|t| t[:date_signed]}.reverse
    array = Array.new
    
    @transactions.each do |t|
      array.push({
        :id => t.id,
        :buyer_id => t.buyer_id,
        :buyer_name => Identity.find(t.buyer_id).self_detail.name_zh,
        :seller_id => t.seller_id,
        :seller_name => Identity.find(t.seller_id).self_detail.name_zh,
        :company_id => t.company_id,
        :company_name => Company.find(t.company_id).name_zh,
        :stock_class => t.stock_class,
        :date_issued => t.date_issued,
        :stock_num => t.stock_num,
        :date_signed => t.date_signed })
    end
    
    return array
  end
  
  def recent_capital_increase
    @capital_increases = self.company.capital_increases.sort_by{|s| s[:date_issued]}.reverse
    array = Array.new
    
    @capital_increases.each do |c|
      array.push({
        :id => c.id,
        :company => c.company_id,
        :company_name => c.company.name_zh,
        :stock_class => c.stock_class,
        :date_issued => c.date_issued,
        :fund => c.fund,
        :currency => c.currency,
        :stock_price => c.stock_price,
        :stock_num => c.stock_num })
    end
    return array
  end
  
end
