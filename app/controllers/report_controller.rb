class ReportController < ApplicationController
  
  def company_report
    
    time = DateTime.now.to_date
    if(params.has_key?(:time))
      time = params[:time]
    end
    
    if params.has_key?(:company_id) && params.has_key?(:stock_class) && params.has_key?(:date_issued)
      @identity = Identity.find_by("company_id": params[:company_id])
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
    end

  end
  
  def contract_report
    @currency_array = [nil, "USD 美金", "RMB 人民幣", "NTD 新台幣"]
    
    if params.has_key?(:company_id) && params.has_key?(:stock_class) && params.has_key?(:date_issued)
      @identity = Identity.find_by("company_id": params[:company_id])
      @capital_increase = CapitalIncrease.where("identity_id=? AND stock_class=? AND date_issued=?",
        @identity.id,
        params[:stock_class],
        params[:date_issued])
    else
      @capital_increase = CapitalIncrease.find(1)
    end
    
    @transactions = Transaction.where("company_id=? AND stock_class=? AND date_issued=?",
      @capital_increase.identity.company_id,
      @capital_increase.stock_class,
      @capital_increase.date_issued)
    
    @complete = @transactions.where("is_completed=?", true)
    @ongoing = @transactions.where("is_completed=? AND is_lacking=?", false, false)
    @lacking = @transactions.where("is_lacking=?", true)
    
    respond_to do |format|
      format.html
      format.csv do
        head = 'EF BB BF'.split(' ').map{|a|a.hex.chr}.join()
        column_names = ["股東姓名", "投資金額/幣別", "每股面額/幣別", "股數", "資料列印", "買方簽署日", "賣方簽署日", "合約生效日", "合約狀態", "更新日期"]
        csv_str = CSV.generate(csv = head) do |csv|
          csv << ["已完成合約"]
          csv << column_names
          @complete.each do |t|
            csv << [Identity.find(t.buyer_id).self_detail.name_zh.to_s,
     	              t.fund_original.to_s + "/" + @currency_array[t.currency_original],
     	              t.stock_price.to_s + "/" + @currency_array[Company.find(t.company_id).currency],
     	              t.stock_num,
     	              t.is_printed ? "已列印" : "未列印",
     	              t.signed_buyer ? t.signed_buyer : "-",
     	              t.signed_seller ? t.signed_seller : "-",
       	            t.date_signed,
       	            "合約已歸檔",
       	            Date.parse(t.updated_at.to_s)]
          end
          
          csv << [""]
          csv << ["進行中合約"]
          csv << column_names
          @ongoing.each do |t|
            csv << [Identity.find(t.buyer_id).self_detail.name_zh.to_s,
     	              t.fund_original.to_s + "/" + @currency_array[t.currency_original],
     	              t.stock_price.to_s + "/" + @currency_array[Company.find(t.company_id).currency],
     	              t.stock_num,
     	              t.is_printed ? "已列印" : "未列印",
     	              t.signed_buyer ? t.signed_buyer : "-",
     	              t.signed_seller ? t.signed_seller : "-",
       	            t.date_signed,
       	            t.is_printed ? "進行中" : "等待印出",
       	            Date.parse(t.updated_at.to_s)]
          end
          
          csv << [""]
          csv << ["待補合約"]
          csv << column_names
          @lacking.each do |t|
            csv << [Identity.find(t.buyer_id).self_detail.name_zh.to_s,
     	              t.fund_original.to_s + "/" + @currency_array[t.currency_original],
     	              t.stock_price.to_s + "/" + @currency_array[Company.find(t.company_id).currency],
     	              t.stock_num,
     	              t.is_printed ? "已列印" : "未列印",
     	              t.signed_buyer ? t.signed_buyer : "-",
     	              t.signed_seller ? t.signed_seller : "-",
       	            t.date_signed,
       	            "資訊待補",
       	            Date.parse(t.updated_at.to_s)]
          end
        end
        send_data csv_str, filename: Identity.find(@capital_increase.identity_id).self_detail.name_zh + "_" + @capital_increase.stock_class + "_" + @capital_increase.date_issued.to_s + ".csv", type: "text/csv"
      end
    end
  end
  
  def lackinfo_report
    @company = params.has_key?(:company_id) ? Company.find(params["company_id"]) : Company.find(1)
    
    if params.has_key?(:company_id)
      @transactions = Transaction.where("company_id=? AND is_lacking=?", params[:company_id], true).order(buyer_id: :asc, id: :asc)
    else
      @transactions = Transaction.where("company_id=? AND is_lacking=?", 1, true).order(buyer_id: :asc, id: :asc)
    end
    
    @report = Array.new
    @s = nil
    @next_s = nil
    @tuple = nil
    
    @transactions.length.times do |i|
      t = @transactions[i]
      @s = Identity.find(t.buyer_id).self_detail
      @next_s = @transactions[i+1] ? Identity.find(@transactions[i+1].buyer_id).self_detail : nil
      
      if @next_s != @s
        
        @tuple = Hash.new
        @tuple[:stockholder_info] = [
            @s.name_zh,
            @s.name_en? ? "O" : "X",
            @s.passport? ? "O" : "X",
            @s.address_zh? ? "O" : "X",
            @s.address_en? ? "O" : "X",
            @s.email? ? "O" : "X",
            @s.copy_passport? ? "O" : "X",
            @s.copy_signature? ? "O" : "X",
            @s.copy_mail_addr? ? "O" : "X"
          ]
        @tuple[:contract_info] = Array.new
        @tuple[:contract_info].push(t.stock_class + " / " + t.date_issued.to_s)
        @tuple[:contract_lack] = Array.new
        lackinfo = [
            t.contract_0_needed ? (t.contract_0? ? "O" : "X") : "-",
            t.contract_1_needed ? (t.contract_1? ? "O" : "X") : "-",
            t.contract_2_needed ? (t.contract_2? ? "O" : "X") : "-",
            t.contract_3_needed ? (t.contract_3? ? "O" : "X") : "-",
            t.contract_4_needed ? (t.contract_4? ? "O" : "X") : "-",
            t.contract_5_needed ? (t.contract_5? ? "O" : "X") : "-",
            t.contract_6_needed ? (t.contract_6? ? "O" : "X") : "-",
            t.contract_7_needed ? (t.contract_7? ? "O" : "X") : "-",
            t.contract_8? ? "O" : "X"
          ]
        @tuple[:contract_lack].push(lackinfo)
        
        @report.push(@tuple)
        
      else
        lackinfo = [
            t.contract_0_needed ? (t.contract_0? ? "O" : "X") : "-",
            t.contract_1_needed ? (t.contract_1? ? "O" : "X") : "-",
            t.contract_2_needed ? (t.contract_2? ? "O" : "X") : "-",
            t.contract_3_needed ? (t.contract_3? ? "O" : "X") : "-",
            t.contract_4_needed ? (t.contract_4? ? "O" : "X") : "-",
            t.contract_5_needed ? (t.contract_5? ? "O" : "X") : "-",
            t.contract_6_needed ? (t.contract_6? ? "O" : "X") : "-",
            t.contract_7_needed ? (t.contract_7? ? "O" : "X") : "-",
            t.contract_8? ? "O" : "X"
          ]
        @tuple[:contract_lack].push(lackinfo)
      
      end
    end
    
    respond_to do |format|
      format.html
      format.csv do
        head = 'EF BB BF'.split(' ').map{|a|a.hex.chr}.join()
        stockholder_col = ["", "英文姓名", "護照號碼", "中文地址", "英文地址", "email",	"護照影本",	"簽名頁影本",	"郵寄地址影本"]
        transactions_col = ["", "意向書",	"Regular S", "USD合約",	"RMB合約", "購買協議", "W8BEN", "換股協議", "聲明書", "銀行水單"]
          
        csv_str = CSV.generate(csv = head) do |csv|
          @report.each do |r|
            csv << stockholder_col
            csv << r[:stockholder_info]
            csv << transactions_col
            r[:contract_lack].length.times do |i|
              tuple = r[:contract_lack][i]
              tuple.insert(0, r[:contract_info][i])
              csv << tuple
            end
          end
        end
        send_data csv_str, filename: @company.name_zh + "_" + "lackinfo" + ".csv", type: "text/csv"
      end
    end
  end
end
