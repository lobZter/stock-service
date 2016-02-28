class StockholdersController < ApplicationController
  
  # GET /stockholders/index
  # GET /stockholders
  def index
  end
  
  # POST /stockholders
  def create
  end
  
  # GET /stockholders/:id
  def show
    @stockholder = Stockholder.find(params[:id])
  end
  
  # PATCH /stockholders/:id
  def update
    @stockholder = Stockholder.find(params[:id])
    @stockholder.update(event_params)

    redirect_to :action => :show, :id => @stockholder
  end
  
  # DELETE /stockholders/:id
  def destroy
    @stockholder = Stockholder.find(params[:id])
    @stockholder.destroy
  
    redirect_to :action => :index
  end
  
  # GET /stockholders/new
  def new
    @stockholder = Stockholder.new
  end
  
  # GET /stockholders/:id/edit
  def edit
    @stockholder = Stockholder.find(params[:id])
  end
  
end
