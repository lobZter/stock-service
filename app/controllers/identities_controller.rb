class IdentitiesController < ApplicationController
  
  def show
    @identity = Identity.find(params[:id])
    
    if @identity.stockholder_id == nil
      @company = Company.find(@identity[:company_id])
      
      respond_to do |format|
        format.html { render :json => @company}
        format.json { render :json => @company}
      end
    elsif @identity.company_id == nil
      @stockholder = Stockholder.find(@identity[:stockholder_id])
      
      respond_to do |format|
        format.html { render :json => @stockholder}
        format.json { render :json => @stockholder}
      end
    end
  end
end
