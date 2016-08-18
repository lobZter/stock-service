class StockholdersController < ApplicationController
  before_action :set_stockholder, :only => [:show, :edit, :update, :destroy]
  
  def index
    if params[:id]
      # GET /stockholders?id=#
      redirect_to stockholder_path(Stockholder.find(params[:id]))
    else
      @stockholders = Stockholder.not_deleted
      
      if params[:set_not_completed]
        @stockholders = @stockholders.filter_not_completed
      end
      
      if params[:set_completed]
        @stockholders = @stockholders.filter_completed
      end
    end
  end
  
  def create
    @stockholder = Stockholder.new(stockholder_params)
    if @stockholder.save
      @identity = Identity.create(:company_id => nil, :stockholder_id => @stockholder.id)
      @stockholder.update({:identity_id => @identity.id})
      
      flash[:saved] = "已儲存"
      redirect_to stockholder_path(@stockholder)
    else
      render :action => :new
    end
  end
  
  def new
    @stockholder = Stockholder.new
  end
  
  def edit
  end
  
  def show
    # 擁有股票
    @stocks =  @stockholder.identity.stock_show
    # 近期交易
    @transactions = @stockholder.identity.recent_transactions
  end
  
  def update
    if @stockholder.update(stockholder_params)
      flash[:saved] = "已儲存"
      redirect_to stockholder_path(@stockholder)
    else
      render :action => :edit
    end
  end
  
  def destroy
    @stockholder.update({is_deleted: true, date_deleted: DateTime.now.to_date})
    redirect_to stockholders_path
  end
  
  def archive
    @stockholders = Stockholder.deleted
  end
  
  
  private
  def set_stockholder
    @stockholder = Stockholder.find(params[:id])
  end
  
  def stockholder_params
    params.require(:stockholder).permit!
  end
  
end
