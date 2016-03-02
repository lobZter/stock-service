class IdentitiesController < ApplicationController
  def show
    @identity = Identity.find(params[:id])
    @company = Company.find(@identity[:company_id])
    
    respond_to do |format|
      format.html { render :json => @company}
      format.json { render :json => @company}
    end
  end
end
