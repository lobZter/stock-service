class CapitalIncreasesController < ApplicationController
  
  # GET /capital_increases/index
  # GET /capital_increases
  def index
    @capital_increases = CapitalIncrease.all
  end
  
  # POST /capital_increases
  def create
    @capital_increaser = capital_increaser.new( capital_increaser_params )
    #@capital_increaser.save
    
    redirect_to root_path
    #redirect_to capital_increaser_url( @capital_increaser )
  end
  
  # GET /capital_increases/new
  def new
    @capital_increase = CapitalIncrease.new
  end
  
  # GET /capital_increases/:id
  def show
    @capital_increaser = capital_increaser.find( params[:id] )
  end
  
  # PATCH /capital_increases/:id
  def update
    @capital_increaser = capital_increaser.find (params[:id] )
    @capital_increaser.update( capital_increaser_params )

    redirect_to :action => :show, :id => @capital_increaser
  end
  
  # DELETE /capital_increases/:id
  def destroy
    @capital_increaser = capital_increaser.find(params[:id])
    @capital_increaser.destroy
  
    redirect_to :action => :index
  end
  
  # GET /capital_increases/:id/edit
  def edit
    @capital_increaser = capital_increaser.find(params[:id])
  end
  
  private
    def capital_increaser_params
      params.require(:capital_increaser).permit(
        :name_zh, :name_en, :is21, :representative,
        :passport, :country, :phone, :wechat, :address, :email,
        :account_bank, :account_num, :account_owner, :account_owner_id,
        :copy_passport, :copy_signature)
    end
end
