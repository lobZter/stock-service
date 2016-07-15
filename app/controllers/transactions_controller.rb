class TransactionsController < ApplicationController
  before_action :set_transaction, :only => [:edit, :update, :destroy]
  before_action :set_data, :only => [:new, :edit]
  layout 'fluid_application', :only => :index
  
  # GET /transactions
  # GET /transactions/index
  def index
    set_data()
    @identities = Hash.new
    @company_names = Hash.new
    @stocks = Array.new
    @transactions = Transaction.all.not_deleted
    @capital_increases = CapitalIncrease.all
    
    if params[:buyer_id].present? && params[:buyer_id] != "0"
      @transactions = @transactions.buyer_id(params[:buyer_id])
    end
    if params[:seller_id].present? && params[:seller_id] != "0"
      @transactions = @transactions.seller_id(params[:seller_id])
    end
    if params[:company_id].present? && params[:stock_class].present? && params[:date_issued].present?
      if params[:company_id] != "undefined" && params[:stock_class] != "undefined" && params[:date_issued] != "undefined"
        @transactions = @transactions.stock(params[:company_id], params[:stock_class], params[:date_issued])
      end
    end
    if params[:set_completed]
      @transactions = @transactions.filter_completed
    elsif params[:set_not_completed]
      @transactions = @transactions.filter_not_completed
    end
    @transactions = @transactions.sort_by{|t| t[:date_signed]}.reverse
    
    @capital_increases.each do |c_i|
      set_stock(c_i)
    end
    
    @transactions.each do |t|
      set_identity(t.seller_id)
      set_identity(t.buyer_id)
      set_company_name(t.company_id)
    end
  end
  
  # POST /transactions
  def create
    if params[:transaction].key?(:stock)
      stock_hash = JSON.parse params[:transaction][:stock]
      stock_hash.delete("id")
      @transaction = Transaction.new(stock_hash.merge(transaction_params))
    else
      @transaction = Transaction.new(transaction_params)
    end
    

    if @transaction.save
      flash[:saved] = "以儲存"
      redirect_to edit_transaction_path(@transaction)
    else
      set_data()
      if @transaction.errors.messages.key?(:stock_num) && @transaction.errors.messages[:stock_num][0] == "交易股數大於賣方擁有股數"
        flash.now[:stock_num] = @transaction.errors.messages[:stock_num][0]
      elsif @transaction.errors.messages.key?(:buyer_id) && @transaction.errors.messages[:buyer_id][0] == "賣方與買方相同"
        flash.now[:buyer_id] = @transaction.errors.messages[:buyer_id][0]
      end
      render :action => :new
    end
  end
 
  # GET /transactions/new
  def new
    @transaction = Transaction.new
    @title = "新增交易"
  end
  
  # GET /transactions/:id/edit
  def edit
    @title = "修改交易"
  end
  
  # PUT /transactions/:id
  def update
    if @transaction.update(transaction_params)
      flash[:saved] = "以儲存"
      redirect_to edit_transaction_path(@transaction)
    else
      set_data()
      render :action => :edit
    end
  end
  
  # DELETE /transactions/:id
  def destroy
    
    buyer_stock = Stock.where("identity_id=?", @transaction.buyer_id)
      .where("company_id=?", @transaction.company_id)
      .where("stock_class=?", @transaction.stock_class)
      .where("date_issued=?", @transaction.date_issued)[0]
    
    if buyer_stock.nil?
      flash[:errors] = "買方剩餘股票數量不合, 無法刪除此交易"
      redirect_to transactions_path
      return
    elsif buyer_stock.stock_num < @transaction.stock_num
      flash[:errors] = "買方剩餘股票數量不合, 無法刪除此交易"
      redirect_to transactions_path
      return
    elsif buyer_stock.stock_num > @transaction.stock_num
      stock_num = buyer_stock.stock_num - @transaction.stock_num
      buyer_stock.update({:stock_num => stock_num})
    else
      buyer_stock.destroy
    end
    
    seller_stock = Stock.where("identity_id=?", @transaction.seller_id)
      .where("company_id=?", @transaction.company_id)
      .where("stock_class=?", @transaction.stock_class)
      .where("date_issued=?", @transaction.date_issued)[0]
    
    if seller_stock.nil?
      Stock.create({
        :dentity_id => @transaction.buyer_id,
        :company_id => @transaction.company_id,
        :stock_class => @transaction.stock_class,
        :date_issued => @transaction.date_issued,
        :stock_num => @transaction.stock_num})
    else
      stock_num = seller_stock.stock_num + @transaction.stock_num
      seller_stock.update({:stock_num => stock_num})
    end
    
    @transaction.update({is_deleted: true})
    redirect_to transactions_path
  end
  
  
  
  private
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
  
  def set_data
    @currency_array = Currency.types
    @companies = Company.all
    @stockholders = Stockholder.all
  end
  
  def transaction_params
    params.require(:transaction).permit( :seller_id, :buyer_id,
        :fund, :currency, :date_paid, :stock_price, :stock_num, :date_signed,
        :contract_0, :contract_1, :contract_2, :contract_3, :contract_4, 
        :contract_5, :contract_6, :contract_7, {contract_8: []},
        :contract_0_needed, :contract_1_needed, :contract_2_needed, :contract_3_needed, 
        :contract_4_needed, :contract_5_needed, :contract_6_needed, :contract_7_needed, 
        :send_buyer, :send_seller, :remark, :remark_contract,
        :fund_original, :currency_original, :exchange_rate, :stock,
        :is_completed, :is_printed, :is_uploaded, :signed_buyer, :signed_seller).except(:stock)
  end

  def set_identity(identity_id)
    if !@identities.has_key?(identity_id)
      @identities[identity_id] = Identity.find(identity_id).self_detail
    else 
      return
    end
  end
  
  def set_company_name(company_id)
    if !@company_names.has_key?(company_id)
      @company_names[company_id] = Company.find(company_id).name_zh
    else 
      return
    end
  end
  
  def set_stock(capital_increase)
    if capital_increase.stock_num > 0
      @stocks.push({
        :company_id => capital_increase.identity.company_id,
        :company_name => capital_increase.identity.self_detail.name_zh,
        :stock_class => capital_increase.stock_class,
        :date_issued => capital_increase.date_issued
      })
    end
  end
  
end
