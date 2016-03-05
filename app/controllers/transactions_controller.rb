class TransactionsController < ApplicationController
  before_action :set_transactions, :only => :index
  layout 'fluid_application', :only => :index
  
  # GET /transactions
  # GET /transactions/index
  def index
    puts @transactions.length
  end
 
  # GET /transactions/new
  def new
    @transaction = Transaction.new
    @currency_array = [["USD", 1], ["RMB", 2], ["NTD", 3]]
    
    @companies = Company.all
    @stockholders = Stockholder.all
  end
  
  # POST /transactions
  def create
    hash = JSON.parse params[:transaction][:stock]
    
    @transaction = Transaction.create( hash.merge!(transaction_params) )

    redirect_to root_path
  end
  
  private
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
  
  private
  
  def set_transactions
    @transactions = Transaction.all
  end
  
end
