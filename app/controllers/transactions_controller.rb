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
    # TODO validation
    stock_hash = JSON.parse params[:transaction][:stock]
    stock_id = stock_hash.delete("id")
    @seller_stock = Stock.find(stock_id)
    @buyer_stock = Stock.where("company_id=?", stock_hash["company_id"]).where("stock_class=?", stock_hash["stock_class"]).where("date_issued=?", stock_hash["date_issued"])
    
    # check stock_num validation
    if @seller_stock.stock_num >= params[:transaction][:stock_num].to_f
      # create transaction
      @transaction = Transaction.create(stock_hash.merge(transaction_params))
      if @transaction.date_signed <= Date.today
      # if Date.strptime(@transaction.date_signed, "%Y-%m-%d") <= Date.today
        if @buyer_stock.size == 0
          # create stock for buyer
          @buyer_stock = Stock.create(stock_hash.merge({"identity_id"=>@transaction.buyer_id, "stock_num"=>@transaction.stock_num}))
        else
          # update stock for buyer
          @buyer_stock = @buyer_stock[0]
          stock_num = @buyer_stock.stock_num + @transaction.stock_num
          @buyer_stock.update({"stock_num"=>stock_num})
        end
        if @seller_stock.stock_num - @transaction.stock_num == 0
          # delete stock for seller
          @seller_stock.destroy
        else
          #update stock for seller
          stock_num = @seller_stock.stock_num - @transaction.stock_num
          @seller_stock.update({"stock_num"=>stock_num})
        end
      end
    end
    
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
