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
  end
  
  private
  
  def set_transactions
    @transactions = Transaction.all
  end
  
end
