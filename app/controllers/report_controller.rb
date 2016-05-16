class ReportController < ApplicationController
  def company_report

  end
  
  def contract_report
    @currency_array = [nil, "USD 美金", "RMB 人民幣", "NTD 新台幣"]
    
    if params[:company_id].present? && params[:stock_class].present? && params[:date_issued].present?
    
    else
      @capital_increase = CapitalIncrease.find(1)
      @transactions = Transaction.where("company_id=? AND stock_class=? AND date_issued=?",
        @capital_increase.identity.company_id,
        @capital_increase.stock_class,
        @capital_increase.date_issued)
      
      @complete = @transactions.where("is_completed=?", true)
      @ongoing = @transactions.where("is_lacking=?", false)
      @lacking = @transactions.where("is_lacking=?", true)
    end
  end
  
  def lackinfo_report
  end
  
end
