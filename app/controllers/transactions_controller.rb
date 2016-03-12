class TransactionsController < ApplicationController
  before_action :set_transaction, :only => [:edit, :update, :destroy]
  before_action :set_data, :only => [:new, :edit]
  layout 'fluid_application', :only => :index
  
  # GET /transactions
  # GET /transactions/index
  def index
    @transactions = Transaction.all
    
    if params[:set_not_completed]
      @transactions = @transactions.filter_not_completed 
    end
    
    if params[:set_completed]
      @transactions = @transactions.filter_completed 
    end
    
    
    puts "-------"
    puts Transaction.filter_completed
    
    @identity_names = Hash.new
    @company_names = Hash.new
    @transactions.each do |t|
      set_identity_name(t.seller_id)
      set_identity_name(t.buyer_id)
      set_company_name(t.company_id)
    end                                
  end
  
  # POST /transactions
  def create
    stock_hash = JSON.parse params[:transaction][:stock]
    stock_hash.delete("id")
    
    @transaction = Transaction.new(stock_hash.merge(transaction_params))
    if @transaction.save
      redirect_to root_path
    else
      set_data()
      if @transaction.errors.messages[:stock_num][0] == "交易股數大於賣方擁有股數"
        flash.now[:stock_num] = @transaction.errors.messages[:stock_num][0]
      end
      render :action => :new
    end
  end
 
  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end
  
  # GET /transactions/:id
  def edit
  end
  
  # PUT /transactions/:id
  def update
    if @transaction.update(transaction_params)
      redirect_to transactions_path
    else
      render :action => :edit
    end
  end
  
  # DELETE /transactions/:id
  def destroy
    
    buyer_stock = Stock.where("identity_id=?", @transaction.buyer_id)
      .where("company_id=?", @transaction.company_id)
      .where("stock_class=?", @transaction.stock_class)
      .where("date_issued=?", @transaction.date_issued)[0]
    
    if buyer_stock.stock_num == @transaction.stock_num
      buyer_stock.destroy
    elsif buyer_stock.stock_num > @transaction.stock_num
      stock_num = buyer_stock.stock_num - @transaction.stock_num
      buyer_stock.update({:stock_num => stock_num})
    else
      flash[:errors] = "買方股票數量不合 無法刪除此交易"
      redirect_to transactions_path
      return
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
    
    @transaction.destroy
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
        :contract_5, :contract_6, :contract_7, :contract_8, :contract_9,
        :contract_0_needed, :contract_1_needed, :contract_2_needed, :contract_3_needed, 
        :contract_4_needed, :contract_5_needed, :contract_6_needed, :contract_7_needed, 
        :send_buyer, :send_seller, :remark, :remark_contract,
        :fund_original, :currency_original, :exchange_rate, :stock).except(:stock)
  end

  def set_identity_name(identity_id)
    if !@identity_names.has_key?(identity_id)
      @identity = Identity.find(identity_id)
      if @identity.company.nil? 
        @identity_names[identity_id] = @identity.stockholder.name_zh
      else @identity.stockholder.nil? 
        @identity_names[identity_id] = @identity.company.name_zh
      end
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
  
end
