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
    @capital_increase = CapitalIncrease.new(capital_increase_params.merge({:stock_checked => false}))
    if@capital_increase.save
      redirect_to root_path
    else
      set_data()
      puts @capital_increase.errors.messages.inspect
      if @capital_increase.errors.messages.key?(:stock_num) && @capital_increase.errors.messages[:stock_num][0] == "減資失敗: 擁有股票數量不足"
        flash.now[:stock_num] = @capital_increase.errors.messages[:stock_num][0]
      elsif @capital_increase.errors.messages.key?(:stock_num) && @capital_increase.errors.messages[:stock_num][0] == "增資失敗: 股票數不可為零"
        flash.now[:stock_num_zero] = @capital_increase.errors.messages[:stock_num][0]
      elsif @capital_increase.errors.messages.key?(:stock_class) && @capital_increase.errors.messages[:stock_class][0] == "減資失敗: 未擁有此股"
        flash.now[:stock_class] = @capital_increase.errors.messages[:stock_class][0]
      end
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
