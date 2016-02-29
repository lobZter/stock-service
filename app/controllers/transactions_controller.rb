class TransactionsController < ApplicationController
  
  # GET /transactions/new
  def new
    @transaction = Transaction.new
    @currency_array = [["USD", 1], ["RMB", 2], ["NTD", 3]]
  end
  
   # POST /transactions
  def create
  end
  
end
