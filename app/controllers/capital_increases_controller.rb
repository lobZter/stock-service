class CapitalIncreasesController < ApplicationController
  
  # GET /capital_increases/index
  # GET /capital_increases
  def index
    @capital_increases = CapitalIncrease.all
    @identities_id = CapitalIncrease.uniq.pluck(:identity_id)
    @companies_name = {}
    @identities_id.each do |identity_id|
      @identity = Identity.find(identity_id)
      @company = Company.find(@identity.company_id)
      
      @companies_name[identity_id] = @company.name_zh
    end
  end
  
  # POST /capital_increases
  def create
    @capital_increase = CapitalIncrease.new(capital_increase_params)
    if@capital_increase.save
      @capital_increase.stock_checked = false
      @capital_increase.save
      # TODO validation
      # @stock = Stock.create(:identity_id => params["capital_increase"]["identity_id"],
      #   :company_id => Identity.find(params["capital_increase"]["identity_id"]).company_id,
      #   :stock_class => params["capital_increase"]["stock_class"],
      #   :stock_num => params["capital_increase"]["stock_num"],
      #   :date_issued => params["capital_increase"]["date_issued"])
      redirect_to root_path
    else
      set_data()
      render :action => :new
    end
  end
  
  # GET /capital_increases/new
  def new
    @capital_increase = CapitalIncrease.new
    set_data()
  end
  
  # DELETE /capital_increases/:id
  def destroy
    @capital_increaser = capital_increaser.find(params[:id])
    @capital_increaser.destroy
    redirect_to capital_increases_path
  end
  
  
  private
  def set_data
    @companies = Company.all
    @currency_array = [["USD", 1], ["RMB", 2], ["NTD", 3]]
  end
  
  def capital_increase_params
    params.require(:capital_increase).permit(:identity_id, :date_issued, :fund, :currency,
        :stock_price, :stock_num, :remark, :created_at, :updated_at, :stock_class)
  end
end
