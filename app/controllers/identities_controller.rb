class IdentitiesController < ApplicationController
  
  def show
    @identity = Identity.find(params[:id])
    @identity.self_detail
    
    respond_to do |format|
      format.html { render :json => @identity.self_detail}
      format.json { render :json => @identity.self_detail}
    end
  end
end
