class ReportController < ApplicationController
  
  def company_report
    
    time = DateTime.now.to_date
    puts "============================" + time.to_s
    if(params.has_key?(:time))
      time = params[:time]
    end
    puts "============================" + time.to_s
    
    if params.has_key?(:company_id) && params.has_key?(:stock_class) && params.has_key?(:date_issued)
      @identity = Identity.find("company_id=?", params[:company_id])
      @capital_increase = CapitalIncrease.where("identity_id=? AND stock_class=? AND date_issued=? AND date_issued<=?",
        @identity.id,
        params[:stock_class],
        params[:date_issued],
        time)
    else
      @capital_increase = CapitalIncrease.find(1)
    end
    
    @transactions = Transaction.where("company_id=? AND stock_class=? AND date_issued=? AND date_signed<=?",
      @capital_increase.identity.company_id, @capital_increase.stock_class, @capital_increase.date_issued, time)
      .order(buyer_id: :asc, company_id: :asc, stock_class: :asc, date_issued: :asc, id: :asc)
    @complete = @transactions.where("is_completed=?", true)
    @ongoing = @transactions.where("is_completed=?", false)
  
    
    @complete_tuple = Array.new
    @complete.each do |c|
      tuple = Hash.new
      tuple[:name_zh] = Identity.find(c.buyer_id).self_detail.name_zh
      tuple[:stock_num] = c.stock_num
      tuple[:percentage] = c.stock_num / @capital_increase.stock_num
      tuple[:stock_class] = c.stock_class
      tuple[:state] = "交易完成"
      @complete_tuple.push(tuple)
    end
    
   
    @ongoing_tuple = Array.new
    @ongoing.each do |c|
      tuple = Hash.new
      tuple[:name_zh] = Identity.find(c.buyer_id).self_detail.name_zh
      tuple[:stock_num] = c.stock_num
      tuple[:percentage] = c.stock_num / @capital_increase.stock_num
      tuple[:stock_class] = c.stock_class
      tuple[:state] = "交易未完成"
      @ongoing_tuple.push(tuple)
    end
        
    respond_to do |format|
      format.html
      format.csv do
        head = 'EF BB BF'.split(' ').map{|a|a.hex.chr}.join()
        column_names = ["姓名", "股數", "占比", "股票類型", "狀態"]
        csv_str = CSV.generate(csv = head) do |csv|
          csv << ["已完成交易股東"]
          csv << column_names
          @complete_tuple.each do |x|
            csv << x.values
          end
          csv << [""]
          csv << ["未完成交易股東"]
          csv << column_names
          @ongoing_tuple.each do |x|
            csv << x.values
          end
        end
        send_data csv_str, filename: "company_report.csv", type: "text/csv"

      end
      
      format.xls { send_data s }
    end

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
    @currency_array = [nil, "USD 美金", "RMB 人民幣", "NTD 新台幣"]
    
    if params[:company_id].present?
      @transactions = Transaction.where("company_id=?", params[:company_id]).order(buyer_id: :asc, id: :asc)
    else
      @transactions = Transaction.where("company_id=?", 1).order(buyer_id: :asc, id: :asc)
    end
  end
  
end
