class StockholdersController < ApplicationController
  
  # GET /stockholders/index
  # GET /stockholders
  def index
    @stockholders = Stockholder.all
  end
  
  # POST /stockholders
  def create
    @stockholder = Stockholder.new stockholder_params
    if @stockholder.save
      redirect_to root_path
      #redirect_to stockholder_url( @stockholder )
    else
      render 'new'
    end
  end
  
  # GET /stockholders/new
  def new
    @stockholder = Stockholder.new
  end
  
  # GET /stockholders/:id
  def show
    @stockholder = Stockholder.find( params[:id] )
  end
  
  # PATCH /stockholders/:id
  def update
    @stockholder = Stockholder.find (params[:id] )
    @stockholder.update( stockholder_params )

    redirect_to :action => :show, :id => @stockholder
  end
  
  # DELETE /stockholders/:id
  def destroy
    @stockholder = Stockholder.find(params[:id])
    @stockholder.destroy
  
    redirect_to :action => :index
  end
  
  # GET /stockholders/:id/edit
  def edit
    @stockholder = Stockholder.find(params[:id])
  end
  
  private
    def stockholder_params
      params.require(:stockholder).permit(
        :name_zh, :name_en, :is21, :representative,
        :passport, :country, :phone, :wechat, :address, :email,
        :account_bank, :account_num, :account_owner, :account_owner_id,
        :copy_passport, :copy_signature)
    end
  
end
