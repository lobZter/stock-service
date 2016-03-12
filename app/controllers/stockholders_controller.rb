class StockholdersController < ApplicationController
  before_action :set_stockholder, :only => [:show, :edit, :update, :destroy]
  
  # GET /stockholders/index
  # GET /stockholders
  def index
    @stockholders = Stockholder.all
  end
  
  # POST /stockholders
  def create
    @stockholder = Stockholder.new(stockholder_params)
    if @stockholder.save
      @identity = Identity.create(:company_id => nil, :stockholder_id => @stockholder.id)
      @stockholder.update({:identity_id => @identity.id})
      redirect_to stockholder_path(@stockholder)
    else
      render :action => :new
    end
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
    @identity = @stockholder.identity
    @stocks = @identity.stock_detail
    @transactions = @identity.recent_transactions
  end
  
  # PUT /stockholders/:id
  def update
    if @stockholder.update(stockholder_params)
      redirect_to stockholder_path(@stockholder)
    else
      render :action => :edit
    end
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
