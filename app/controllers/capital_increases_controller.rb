class CapitalIncreasesController < ApplicationController
  before_action :set_capital_increase, :only => [:edit, :update, :destroy]
  before_action :set_data, :only => [:new, :edit]
  
  # GET /capital_increases/index
  # GET /capital_increases
  def index
    set_data()
    
    @capital_increases = CapitalIncrease.order("updated_at DESC")
    @capital_increases = @capital_increases.company(params[:identity_id]) if params[:identity_id].present?
    
    @companies_name = {}
    @capital_increases.each do |c_i|
      @companies_name[c_i.identity.id] = c_i.identity.company.name_zh
      c_i.identity.company.name_zh
    end
  end
  
  # POST /capital_increases
  def create
    @capital_increase = CapitalIncrease.new(capital_increase_params.merge({:stock_checked => false, :is_first => false}))

    if @capital_increase.save
      # Create investors
      investor_params[:stockholder_id].length.times do |i|
        if(investor_params[:fund][i] != "" && investor_params[:stock_num][i] != "")
          
          Investor.create(:capital_increase_id => @capital_increase.id,
            :stockholder_id => investor_params[:stockholder_id][i],
            :fund => investor_params[:fund][i],
            :stock_price => @capital_increase.stock_price,
            :stock_num => investor_params[:stock_num][i])
        end
      end
      
      redirect_to root_path
    else
      @investors = Array.new
      
      investor_params[:stockholder_id].length.times do |i|
        @investor = Investor.new({
          :stockholder_id => investor_params[:stockholder_id][i],
          :fund => investor_params[:fund][i],
          :stock_num => investor_params[:stock_num][i]})
        @investors.push(@investor)
      end
      
      set_data()
      puts @capital_increase.errors.messages.inspect
      if @capital_increase.errors.messages.key?(:stock_num) && @capital_increase.errors.messages[:stock_num][0] == "減資失敗: 擁有股票數量不足"
        flash.now[:stock_num] = @capital_increase.errors.messages[:stock_num][0]
      elsif @capital_increase.errors.messages.key?(:stock_num) && @capital_increase.errors.messages[:stock_num][0] == "增資失敗: 股票數不可為零"
        flash.now[:stock_num_zero] = @capital_increase.errors.messages[:stock_num][0]
      elsif @capital_increase.errors.messages.key?(:stock_class) && @capital_increase.errors.messages[:stock_class][0] == "減資失敗: 未擁有此股"
        flash.now[:stock_class] = @capital_increase.errors.messages[:stock_class][0]
      elsif @capital_increase.errors.messages.key?(:date_issued) && @capital_increase.errors.messages[:date_issued][0] == "增資失敗: 不可增資同發行日期之股票"
        flash.now[:date_issued] = @capital_increase.errors.messages[:date_issued][0]
      end
      
      
      
      render :action => :new
    end

  end
  
  # GET /capital_increases/new
  def new
    @capital_increase = CapitalIncrease.new
  end
  
  # GET /capital_increases/:id/edit
  def edit
    @investors = Investor.where("capital_increase_id=?", @capital_increase.id)
  end
  
  # PUT /capital_increases/:id
  def update
    if @capital_increase.update(capital_increase_params)
      Investor.where("capital_increase_id=?", @capital_increase.id).destroy_all
      
      investor_params[:stockholder_id].length.times do |i|
        if(investor_params[:fund][i] != "" && investor_params[:stock_num][i] != "")
          
          Investor.create(:capital_increase_id => @capital_increase.id,
            :stockholder_id => investor_params[:stockholder_id][i],
            :fund => investor_params[:fund][i],
            :stock_price => @capital_increase.stock_price,
            :stock_num => investor_params[:stock_num][i])
        end
      end
      
      redirect_to capital_increases_path
    else
      set_data()
      render :action => :edit
    end
  end
  
  # DELETE /capital_increases/:id
  def destroy
    
    if !@capital_increase.is_first
      if @capital_increase.stock_checked
    
        remaining_stock = Stock.where("company_id=?", @capital_increase.identity.company_id)
          .where("stock_class=?", @capital_increase.stock_class)
          .where("date_issued=?", @capital_increase.date_issued)
          .where("identity_id=?", @capital_increase.identity_id)[0]
      
        if @capital_increase.stock_num > 0
          if remaining_stock.nil?
            flash[:errors] = "剩餘股票數量不合 無法刪除此筆增資"
          elsif remaining_stock.stock_num < @capital_increase.stock_num
            flash[:errors] = "買方剩餘股票數量不合 無法刪除此筆增資"
          elsif remaining_stock.stock_num > @capital_increase.stock_num
            stock_num = remaining_stock.stock_num - @capital_increase.stock_num
            remaining_stock.update({:stock_num => stock_num})
            @capital_increase.destroy
          else
            remaining_stock.destroy
            @capital_increase.destroy
          end
        else
          if remaining_stock.nil?
            Stock.create({
              :identity_id => @capital_increase.identity_id,
              :company_id => @capital_increase.identity.company_id,
              :stock_class => @capital_increase.stock_class,
              :date_issued => @capital_increase.date_issued,
              :stock_num => -@capital_increase.stock_num})
            @capital_increase.destroy
          else
            stock_num = remaining_stock.stock_num - @capital_increase.stock_num
            remaining_stock.update({:stock_num => stock_num})
            @capital_increase.destroy
          end
        end
        
      else
        @capital_increase.destroy
      end
    else
      flash[:errors] = "此筆為起始資本 無法刪除此筆增資"
    end
    
    redirect_to capital_increases_path
  end
  
  
  private
  def set_data
    @companies = Company.all
    @stockholders = Stockholder.all
    @currency_array = Currency.types
  end
  
  def set_capital_increase
    @capital_increase = CapitalIncrease.find(params[:id])
  end
  
  def capital_increase_params
    params.require(:capital_increase).permit(:identity_id, :date_issued, :fund, :currency,
        :stock_price, :stock_num, :remark, :created_at, :updated_at, :stock_class, :date_decreased)
  end
  
  def investor_params
    params.require(:investor).permit({stockholder_id: []}, {fund: []}, {stock_num: []})
  end
end
