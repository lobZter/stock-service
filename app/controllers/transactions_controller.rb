class TransactionsController < ApplicationController
  before_action :set_transaction, :only => [:edit, :update, :destroy, :delete]
  layout 'fluid_application', :only => :index
  
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
  
  def create
    if params[:transaction].key?(:stock)
      stock_hash = JSON.parse params[:transaction][:stock]
      stock_hash.delete("id")
      @transaction = Transaction.new(stock_hash.merge(transaction_params))
    else
      @transaction = Transaction.new(transaction_params)
    end
    
    if @transaction.save
      flash[:saved] = "已儲存"
      redirect_to edit_transaction_path(@transaction)
    else
      # set flash by error messages
      @transaction.errors.messages.each do |key, msg|
        flash.now[key] = msg.first
      end
      
      set_data()
      render :action => :new
    end
  end
 
  def new
    set_data()
    @transaction = Transaction.new
  end
  
  def edit
    set_data()
  end
  
  def update
    if @transaction.update(transaction_params)
      flash[:saved] = "已儲存"
      redirect_to edit_transaction_path(@transaction)
    else
      set_data()
      render :action => :edit
    end
  end
  
  def destroy
    if not @transaction.destroy
      # set flash by error messages
      @transaction.errors.messages.each do |key, msg|
        flash[key] = msg.first
      end
    end
      
    redirect_to transactions_path
  end
  
  # 封存
  def delete
    if not @capital_increase.update({is_deleted: true, date_deleted: DateTime.now.to_date})
      # set flash by error messages
      @capital_increase.errors.messages.each do |key, msg|
        flash[key] = msg.first
      end
    end
    
    redirect_to capital_increases_path
  end
  
  
  private
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
  
  def set_data
    @companies = Company.not_deleted
    @stockholders = Stockholder.not_deleted
  end
  
  def transaction_params
    params.require(:transaction).except(:stock).permit!
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
        :company_id => capital_increase.company.id,
        :company_name => capital_increase.company.name_zh,
        :stock_class => capital_increase.stock_class,
        :date_issued => capital_increase.date_issued
      })
    end
  end
  
end
