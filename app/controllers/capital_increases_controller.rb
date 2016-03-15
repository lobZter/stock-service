class CapitalIncreasesController < ApplicationController
  
  # GET /capital_increases/index
  # GET /capital_increases
  def index
    set_data()
    
    @capital_increases = CapitalIncrease.all
    @capital_increases = @capital_increases.company(params[:identity_id]) if params[:identity_id].present?
    
    @companies_name = {}
    @capital_increases.each do |c_i|
      @companies_name[c_i.identity.id] = c_i.identity.company.name_zh
      c_i.identity.company.name_zh
    end
  end
  
  # POST /capital_increases
  def create
    @capital_increase = CapitalIncrease.new(capital_increase_params.merge({:stock_checked => false}))
    
    if @capital_increase.remark != "起始增資"
    
      if @capital_increase.save
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
        elsif @capital_increase.errors.messages.key?(:date_issued) && @capital_increase.errors.messages[:date_issued][0] == "增資失敗: 不可增資同發行日期之股票"
          flash.now[:date_issued] = @capital_increase.errors.messages[:date_issued][0]
        end
        render :action => :new
      end
      
    else
      set_data()
      @capital_increase.errors.add(:remark, '備註不可為 "起始增資"')
      flash.now[:remark] = '備註不可為 "起始增資"'
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
    @capital_increase = CapitalIncrease.find(params[:id])
    
    if @capital_increase.remark != "起始增資"
    
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
    @currency_array = Currency.types
  end
  
  def capital_increase_params
    params.require(:capital_increase).permit(:identity_id, :date_issued, :fund, :currency,
        :stock_price, :stock_num, :remark, :created_at, :updated_at, :stock_class)
  end
end
