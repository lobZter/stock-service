class CapitalIncreasesController < ApplicationController
  
  # # GET /capital_increases/index
  # # GET /capital_increases
  def index
    @capital_increases = CapitalIncrease.all
    @identities_id = CapitalIncrease.uniq.pluck(:identity_id)
    # puts "DEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUG"
    # puts @identities_id
    # puts "DEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUG"
    @companies_name = {}
    @identities_id.each do |identity_id|
      @identity = Identity.find(identity_id)
      @company = Company.find(@identity.company_id)
      
      @companies_name[identity_id] = @company.name_zh
    end
    
    
      # puts "DEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUG"
      # puts companies_name
      # puts "DEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUGDEBUG"
    
    # @identities = Identity.where.not(:company_id => nil)
    # @companies = @identities.map { |i| Company.find(i.company_id) }
    
    # @capital_increases.each do |c_i|
    #   if c_i
    # end
  end
  
  # POST /capital_increases
  def create
    @capital_increase = CapitalIncrease.create( capital_increase_params )
    # @stock = Stock.create(:identity_id => params["capital_increase"]["identity_id"],
    #                       :company_id => Identity.find(params["capital_increase"]["identity_id"]).company_id,
    #                       :stock_class => params["capital_increase"]["stock_class"],
    #                       :stock_num => params["capital_increase"]["stock_num"])
    
    redirect_to root_path
  end
  
  # GET /capital_increases/new
  def new
    @capital_increase = CapitalIncrease.new
    @companies = Company.all
    @currency_array = [["USD", 1], ["RMB", 2], ["NTD", 3]]
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
