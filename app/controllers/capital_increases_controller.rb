class CapitalIncreasesController < ApplicationController
  
  # # GET /capital_increases/index
  # # GET /capital_increases
  # def index
  #   @capital_increases = CapitalIncrease.all
  # end
  
  # POST /capital_increases
  def create
    @capital_increase = CapitalIncrease.create( capital_increase_params )
    redirect_to root_path
  end
  
  # GET /capital_increases/new
  def new
    @capital_increase = CapitalIncrease.new
    @companies = Company.all

    @companies.each do |c|
      puts c.identity.id
      
    end
    #print @companies.map { |c| [c.name_zh, c.identity.id] } 
  end
  
  # # GET /capital_increases/:id
  # def show
  #   @capital_increaser = capital_increaser.find( params[:id] )
  # end
  
  # # PATCH /capital_increases/:id
  # def update
  #   @capital_increaser = capital_increaser.find (params[:id] )
  #   @capital_increaser.update( capital_increaser_params )

  #   redirect_to :action => :show, :id => @capital_increaser
  # end
  
  # # DELETE /capital_increases/:id
  # def destroy
  #   @capital_increaser = capital_increaser.find(params[:id])
  #   @capital_increaser.destroy
  
  #   redirect_to :action => :index
  # end
  
  # # GET /capital_increases/:id/edit
  # def edit
  #   @capital_increaser = capital_increaser.find(params[:id])
  # end
  
  private
    def capital_increase_params
      params.require(:capital_increase).permit(:identity_id, :date_issued, :fund, :currency,
                     :stock_price, :stock_num, :remark, :created_at, :updated_at, :stock_class)
    end
end
