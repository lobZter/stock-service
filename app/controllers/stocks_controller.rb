class StocksController < ApplicationController
  
  # GET /identities/:id/stocks
  def index
    @identity = Identity.find(params[:identity_id])
    @stocks = @identity.stock_detail
    
    respond_to do |format|
      format.html { render :json => @stocks}
      format.json { render :json => @stocks}
    end

  end
end
