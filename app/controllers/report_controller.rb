class ReportController < ApplicationController
  
  def company_report
    @capital_increases = CapitalIncrease.all
    @companies = Company.all
    
    start_time = Time.new(1970, 1, 1, 12, 10).to_date
    if(params.has_key?(:start_time) && params[:start_time] != "")
      start_time = params[:start_time]
      start_time.gsub! '/', '-'
    end
    
    end_time = DateTime.now.to_date
    if(params.has_key?(:end_time) && params[:end_time] != "")
      end_time = params[:end_time]
      end_time.gsub! '/', '-'
    end
    
    if params.has_key?(:company_id) && params[:company_id] != "" && params.has_key?(:stock) && params[:stock] != ""
      stock_hash = JSON.parse params[:stock]
      puts stock_hash.inspect
      @identity = Company.find(params[:company_id]).identity
      @capital_increase = CapitalIncrease.where("identity_id=? AND stock_class=? AND date_issued=?", @identity.id, stock_hash["stock_class"], stock_hash["date_issued"])
        .where("date_decreased is null OR date_decreased=?", "")[0]
    else
      @capital_increase = @capital_increases[0]
    end
    
    @identity = Identity.find(@capital_increase.identity_id)
     
    @transactions = Transaction.where("company_id=? AND stock_class=? AND date_issued=? AND date_signed>=? AND date_signed<=?",
      @capital_increase.identity.company_id, @capital_increase.stock_class, @capital_increase.date_issued, start_time, end_time)
      
    @complete = @transactions.where("is_signed=? AND is_lacking=?", true, false).order(buyer_id: :asc)
    @ongoing = @transactions.where("is_signed=? OR is_lacking=?", false, true).order(stock_num: :desc)
    
    
    @complete_tuple = Array.new
    @s = nil
    @last_s = nil
    @complete.each do |c|
      @s = c.buyer_id
      if(@s != @last_s)
        tuple = Hash.new
        tuple[:name_zh] = Identity.find(c.buyer_id).self_detail.name_zh
        tuple[:stock_num] = c.stock_num
        tuple[:percentage] = (c.stock_num / @capital_increase.stock_num).round(5)
      
        @complete_tuple.push(tuple)
      else
        @complete_tuple[@complete_tuple.length-1][:percentage] += (c.stock_num / @capital_increase.stock_num).round(5)
        @complete_tuple[@complete_tuple.length-1][:stock_num] += c.stock_num
      end
      @last_s = @s
    end
    @complete_tuple.sort_by{|c| -c[:stock_num]}
    
    @ongoing_tuple = Array.new
    @ongoing.each do |c|
      tuple = Hash.new
      tuple[:transaction_id] = c.id
      tuple[:name_zh] = Identity.find(c.buyer_id).self_detail.name_zh
      tuple[:stock_num] = c.stock_num
      tuple[:percentage] = (c.stock_num / @capital_increase.stock_num).round(5)
      @ongoing_tuple.push(tuple)
    end
        
    respond_to do |format|
      format.html
      format.xlsx do
        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "股東占比") do |sheet|
          sheet.add_row ["股東姓名", "股數", "占比"]
          @complete_tuple.each do |x|
            sheet.add_row x.values
          end
        end
        
        p.workbook.add_worksheet(:name => "待完成交易") do |sheet|
          sheet.add_row ["股東姓名", "股數", "占比"]
          @ongoing_tuple.each do |x|
            sheet.add_row x.except(:transaction_id).values
          end
        end
 
        send_data p.to_stream.read,
          filename: @capital_increase.identity.self_detail.name_zh+"_"+@capital_increase.stock_class+"_"+@capital_increase.date_issued.to_s + ".xlsx", 
          type: "application/xlsx"
      end
    end
  end
  
  def contract_report
    @currency_array = [nil, "USD 美金", "RMB 人民幣", "NTD 新台幣"]
    @capital_increases = CapitalIncrease.all
    
    if params.has_key?(:id) && params[:id] != ""
      @capital_increase = CapitalIncrease.find(params[:id])
    else
      @capital_increase = @capital_increases[0]
    end
    @identity = Identity.find(@capital_increase.identity_id)
    
    @transactions = Transaction.where("company_id=? AND stock_class=? AND date_issued=?",
      @capital_increase.identity.company_id,
      @capital_increase.stock_class,
      @capital_increase.date_issued)
    
    @complete = @transactions.where("is_signed=? AND is_lacking=?", true, false)
    @lacking = @transactions.where("is_signed=? AND is_lacking=?", true, true)
    @not_signed = @transactions.where("is_signed=? AND is_lacking=?", false, false)
    @not_complete = @transactions.where("is_signed=? AND is_lacking=?", false, true)
    
    respond_to do |format|
      format.html
      format.xlsx do
        column_names = ["股東姓名", "投資金額/幣別", "每股面額/幣別", "股數", "資料列印", "買方簽署日", "賣方簽署日", "合約生效日", "合約狀態", "更新日期"]
        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "已完成合約") do |sheet|
          sheet.add_row column_names
          @complete.each do |t|
            sheet.add_row [Identity.find(t.buyer_id).self_detail.name_zh.to_s,
     	              t.fund_original.to_s + "/" + @currency_array[t.currency_original],
     	              t.stock_price.to_s + "/" + @currency_array[Company.find(t.company_id).currency],
     	              t.stock_num,
     	              t.is_printed ? "已列印" : "未列印",
     	              t.signed_buyer ? t.signed_buyer : "-",
     	              t.signed_seller ? t.signed_seller : "-",
       	            t.date_signed,
       	            "已完成",
       	            Date.parse(t.updated_at.to_s)]
          end
        end
        
        p.workbook.add_worksheet(:name => "已簽署 資料待補") do |sheet|
          sheet.add_row column_names
          @lacking.each do |t|
            sheet.add_row [Identity.find(t.buyer_id).self_detail.name_zh.to_s,
     	              t.fund_original.to_s + "/" + @currency_array[t.currency_original],
     	              t.stock_price.to_s + "/" + @currency_array[Company.find(t.company_id).currency],
     	              t.stock_num,
     	              t.is_printed ? "已列印" : "未列印",
     	              t.signed_buyer ? t.signed_buyer : "-",
     	              t.signed_seller ? t.signed_seller : "-",
       	            t.date_signed,
       	            "資料待補",
       	            Date.parse(t.updated_at.to_s)]
          end
        end
        
        p.workbook.add_worksheet(:name => "未完成簽署 資料齊全") do |sheet|
          sheet.add_row column_names
          @not_signed.each do |t|
            sheet.add_row [Identity.find(t.buyer_id).self_detail.name_zh.to_s,
     	              t.fund_original.to_s + "/" + @currency_array[t.currency_original],
     	              t.stock_price.to_s + "/" + @currency_array[Company.find(t.company_id).currency],
     	              t.stock_num,
     	              t.is_printed ? "已列印" : "未列印",
     	              t.signed_buyer ? t.signed_buyer : "-",
     	              t.signed_seller ? t.signed_seller : "-",
       	            t.date_signed,
       	            "待簽約",
       	            Date.parse(t.updated_at.to_s)]
          end
        end
        
        p.workbook.add_worksheet(:name => "未完成簽署 資料待補") do |sheet|
          sheet.add_row column_names
          @not_complete.each do |t|
            sheet.add_row [Identity.find(t.buyer_id).self_detail.name_zh.to_s,
     	              t.fund_original.to_s + "/" + @currency_array[t.currency_original],
     	              t.stock_price.to_s + "/" + @currency_array[Company.find(t.company_id).currency],
     	              t.stock_num,
     	              t.is_printed ? "已列印" : "未列印",
     	              t.signed_buyer ? t.signed_buyer : "-",
     	              t.signed_seller ? t.signed_seller : "-",
       	            t.date_signed,
       	            "資料待補",
       	            Date.parse(t.updated_at.to_s)]
          end
        end
 
        send_data p.to_stream.read,
          filename: @capital_increase.identity.self_detail.name_zh+"_"+@capital_increase.stock_class+"_"+@capital_increase.date_issued.to_s + ".xlsx", 
          type: "application/xlsx"
      end
    end
  end
  
  def lackinfo_report
    @companies = Company.all
    if params.has_key?(:id) && params[:id] != ""
      @company = Company.find(params[:id])
    else
      @company = @companies[0]
    end

    @transactions = Transaction.where("company_id=? AND is_lacking=?", @company.id, true).order(buyer_id: :asc, id: :asc)
   
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
            @s.country? ? "O" : "X",
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
      format.xlsx do
        stockholder_col = ["", "英文姓名", "護照號碼", "國籍", "中文地址", "英文地址", "email",	"護照影本",	"簽名頁影本",	"郵寄地址影本"]
        transactions_col = ["", "意向書",	"Regular S", "USD合約",	"RMB合約", "購買協議", "W8BEN", "換股協議", "聲明書", "銀行水單"]
          
        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "股東占比") do |sheet|
          @report.each do |r|
            sheet.add_row stockholder_col
            sheet.add_row r[:stockholder_info]
            sheet.add_row transactions_col
            r[:contract_lack].length.times do |i|
              tuple = r[:contract_lack][i]
              tuple.insert(0, r[:contract_info][i])
              sheet.add_row tuple
            end
            sheet.add_row [""]
            sheet.add_row [""]
          end
        end
 
        send_data p.to_stream.read,
          filename: @company.name_zh + "_" + "lackinfo.xlsx", 
          type: "application/xlsx"
      end
    end
  end
end
