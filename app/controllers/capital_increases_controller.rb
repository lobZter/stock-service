class CapitalIncreasesController < ApplicationController
  before_action :set_capital_increase, :only => [:edit, :update, :destroy]
  before_action :set_data, :only => [:new, :edit]
  
  def index
    set_data()
    
    # script to update company_id
    # @capital_increases = CapitalIncrease.all
    # @capital_increases.each do |c_i|
    #   c_i.update({:company_id => Identity.find(c_i.identity_id).company_id})
    # end
    
    @capital_increases = CapitalIncrease.order("updated_at DESC")
    @capital_increases = @capital_increases.company(params[:company_id]) if params[:company_id].present?
  end
  
  def create
    @capital_increase = CapitalIncrease.new(capital_increase_params)

    if @capital_increase.save
      # Create investors
      if check_investor_params
        investor_params[:stockholder_id].length.times do |i|
          if not investor_params[:fund][i].blank? and not investor_params[:stock_num][i].blank?
            Investor.create(:capital_increase_id => @capital_increase.id,
              :stockholder_id => investor_params[:stockholder_id][i],
              :fund => investor_params[:fund][i],
              :stock_price => @capital_increase.stock_price,
              :stock_num => investor_params[:stock_num][i])
          end
        end
      end
      
      redirect_to capital_increases_path
    else
      # prepare global parameter for displaying inventors
      @investors = Array.new
      investor_params[:stockholder_id].length.times do |i|
        @investors.push(
          Investor.new({
            :stockholder_id => investor_params[:stockholder_id][i],
            :fund => investor_params[:fund][i],
            :stock_num => investor_params[:stock_num][i]}))
      end
      
      # set flash by error messages
      @capital_increase.errors.messages.each do |key, msg|
        flash.now[key] = msg.first
      end
      
      set_data()
      render :action => :new
    end
  end
  
  def new
    @capital_increase = CapitalIncrease.new
  end
  
  def edit
    @investors = Investor.where("capital_increase_id=?", @capital_increase.id)
  end
  
  def update
    if @capital_increase.update(capital_increase_params)
      if check_investor_params
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
      end
      redirect_to capital_increases_path
    else
      # prepare global parameter for displaying inventors
      @investors = Array.new
      investor_params[:stockholder_id].length.times do |i|
        @investors.push(
          Investor.new({
            :stockholder_id => investor_params[:stockholder_id][i],
            :fund => investor_params[:fund][i],
            :stock_num => investor_params[:stock_num][i]}))
      end
      
      set_data()
      render :action => :edit
    end
  end
  
  def destroy
    
    if not @capital_increase.is_first
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
    @companies = Company.not_deleted
    @currency_array = Currency.types
  end
  
  def set_capital_increase
    @capital_increase = CapitalIncrease.find(params[:id])
  end
  
  def capital_increase_params
    params.require(:capital_increase).permit!
  end
  
  def investor_params
    params.permit(:investor)
  end
  
  def check_investor_params
    
    # no investor
    if investor_params.empty?
      return false
    end
    
    if investor_params[:stockholder_id].length != investor_params[:fund].length || investor_params[:stockholder_id].length != investor_params[:stock_num].length
      return false
    end
    
    return true
    
  end
end
