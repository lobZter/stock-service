class StocksController < ApplicationController
   
  def stock_class
    params.each do |key,value|
      puts "Param #{key}: #{value}"
    end
    
    @stocks = Stock.where("identity_id= ? ", params[:identity_id])
    
    respond_to do |format|
      format.html { render :json => @stocks}
      format.json { rend er :json => @stocks}
    end

  end
end
