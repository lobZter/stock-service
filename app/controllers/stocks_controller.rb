class StocksController < ApplicationController
  
  # GET /identities/:id/stocks
  def index
    @identity = Identity.find(params[:identity_id])
    @stocks = @identity.stocks
    
    stock_array = Array.new
    @stocks.each do |s|
      stock_hash= Hash.new
      stock_hash[:id] = s.id
      stock_hash[:identity_id] = s.identity_id
      stock_hash[:company_id] = s.company_id
      stock_hash[:company_name] = Company.find(s.company_id).name_zh
      stock_hash[:stock_class] = s.stock_class
      stock_hash[:date_issued] = s.date_issued
      stock_hash[:stock_num] = s.stock_num
      stock_array.push(stock_hash)
    end
    
    respond_to do |format|
      format.html { render :json => stock_array}
      format.json { render :json => stock_array}
    end

  end
end
