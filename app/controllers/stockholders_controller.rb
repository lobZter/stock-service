class StockholdersController < ApplicationController
  before_action :set_stockholder, :only => [:show, :edit, :update, :destroy]
  
  # GET /stockholders/index
  # GET /stockholders
  def index
    @stockholders = Stockholder.all
  end
  
  # POST /stockholders
  def create
    @stockholder = Stockholder.create(stockholder_params)
    @identity = Identity.create(:company_id => nil, :stockholder_id => @stockholder.id)
    
    redirect_to root_path
    
    #if @stockholder.save
    #  redirect_to stockholder_path(@stockholder)
    #else
    #  render 'new'
    #end
  end
  
  # GET /stockholders/new
  def new
    @stockholder = Stockholder.new
  end
  
  # GET /stockholders/:id/edit
  def edit
  end
  
  # GET /stockholders/:id
  def show
    @stocks = Stock.where("identity_id= ?", Stockholder.find(params[:id]).identity.id)
  end
  
  # PUT /stockholders/:id
  def update
    @stockholder.update(stockholder_params)

    redirect_to stockholder_path( @stockholder )
  end
  
  # DELETE /stockholders/:id
  def destroy
    @stockholder.destroy
  
    redirect_to root_path
  end
  
  private
  def set_stockholder
    @stockholder = Stockholder.find(params[:id])
  end
  
  def stockholder_params
    params.require(:stockholder).permit(
      :name_zh, :name_en, :is21, :representative,
      :passport, :country, :phone, :wechat, :address, :email,
      :account_bank, :account_num, :account_owner, :account_owner_id,
      :copy_passport, :copy_signature)
  end
  
end
