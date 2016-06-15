class StocksController < ApplicationController
  
  # GET /identities/:id/stocks
  def index
    if params.has_key? :identity_id
      @identity = Identity.find(params[:identity_id])
      @stocks = @identity.stock_detail
    elsif params.has_key? :company_id
      @identity = Company.find(params[:company_id]).identity
      @stocks = CapitalIncrease.where("identity_id=?", @identity.id).where("date_decreased is null OR date_decreased=?", "")
    end
    
    respond_to do |format|
      format.html { render :json => @stocks}
      format.json { render :json => @stocks}
    end

  end
end
