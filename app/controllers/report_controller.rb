class ReportController < ApplicationController
  layout 'fluid_application', :only => :lackinfo_report
  
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
      stock_json = params[:stock].gsub "'", "\""
      stock_hash = JSON.parse stock_json
      
      @identity = Company.find(params[:company_id]).identity
      @capital_increase = CapitalIncrease.where("identity_id=? AND stock_class=? AND date_issued=?", @identity.id, stock_hash["stock_class"], stock_hash["date_issued"])
        .where("date_decreased is null OR date_decreased=?", "")[0]
    else
      @capital_increase = @capital_increases[0]
    end
    
    @identity = Identity.find(@capital_increase.identity_id)
     
    @transactions = Transaction.where("company_id=? AND stock_class=? AND date_issued=? AND date_signed>=? AND date_signed<=?",
      @capital_increase.identity.company_id, @capital_increase.stock_class, @capital_increase.date_issued, start_time, end_time)
      
    @complete = @transactions.where("is_signed=? AND is_lacking=?", true, false)
    @ongoing = @transactions.where("is_signed=? OR is_lacking=?", false, true).order(stock_num: :desc)
    
    @complete_hash = Hash.new
    @complete_hash[@capital_increase.identity_id] = Hash.new
    @complete_hash[@capital_increase.identity_id][:stock_num] = @capital_increase.stock_num
    @complete_hash[@capital_increase.identity_id][:name_zh] = Identity.find(@capital_increase.identity_id).self_detail.name_zh
    @complete_hash[@capital_increase.identity_id][:percentage] = 0
    
    @complete.each do |t|
      if not @complete_hash.has_key? t.buyer_id
        @complete_hash[t.buyer_id] = Hash.new
        @complete_hash[t.buyer_id][:name_zh] = Identity.find(t.buyer_id).self_detail.name_zh
        @complete_hash[t.buyer_id][:stock_num] = 0
        @complete_hash[t.buyer_id][:percentage] = 0
      end
      
      if not @complete_hash.has_key? t.seller_id
        @complete_hash[t.seller_id] = Hash.new
        @complete_hash[t.seller_id][:name_zh] = Identity.find(t.seller_id).self_detail.name_zh
        @complete_hash[t.seller_id][:stock_num] = 0
        @complete_hash[t.seller_id][:percentage] = 0
      end
    end
    
    @complete.each do |t|
      @complete_hash[t.buyer_id][:stock_num] += t.stock_num
      @complete_hash[t.seller_id][:stock_num] -= t.stock_num
    end
    
    @complete_tuple = @complete_hash.values
    @complete_tuple.each do |c|
      c[:percentage] = (c[:stock_num] / @capital_increase.stock_num).round(5)
    end
    @complete_tuple.sort_by! {|a| -a[:percentage]}
    
    
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
    @currency_array = [nil, "USD 美金", "RMB 人民幣", "NTD 新台幣"]
    @companies = Company.all
    if params.has_key?(:id) && params[:id] != ""
      @company = Company.find(params[:id])
    else
      @company = @companies[0]
    end

    @transactions = Transaction.where("company_id=? AND is_lacking=?", @company.id, true).order(buyer_id: :asc, id: :asc)
    @report = Array.new
    @tuple = nil
    
    @transactions.each do |t|
      @identity = Identity.find(t.buyer_id).self_detail
      @tuple = Hash.new
      
      @tuple[:transaction_id] = t.id
      
      if @identity.class.name == "Stockholder"
        @tuple[:name_zh] = @identity.name_zh
        @tuple[:fund] = t.fund_original.to_s + "/" + @currency_array[t.currency_original]
        @tuple[:stock_price] = t.stock_price.to_s + "/" + @currency_array[@company.currency]
        @tuple[:stock_num] = t.stock_num.to_s
        @tuple[:name_en] = @identity.name_en? ? "O" : "X"
        @tuple[:passport] = @identity.passport? ? "O" : "X"
        @tuple[:country] = @identity.country? ? "O" : "X"
        @tuple[:address_zh] = @identity.address_zh? ? "O" : "X"
        @tuple[:address_en] = @identity.address_en? ? "O" : "X"
        @tuple[:email] = @identity.email? ? "O" : "X"
        @tuple[:copy_passport] = @identity.copy_passport? ? "O" : "X"
        @tuple[:copy_signature] = @identity.copy_signature? ? "O" : "X"
        @tuple[:copy_mail_addr] = @identity.copy_mail_addr? ? "O" : "X"
      end
      
      if @identity.class.name == "Company"
        @tuple[:name_zh] = @identity.name_zh
        @tuple[:fund] = t.fund_original + "/" + @currency_array[t.currency_original]
        @tuple[:stock_price] = t.stock_price + "/" + @currency_array[@company.currency]
        @tuple[:stock_num] = t.stock_num
        @tuple[:name_en] = @identity.name_en? ? "O" : "X"
        @tuple[:passport] = "-"
        @tuple[:country] = "-"
        @tuple[:address_zh] = "-"
        @tuple[:address_en] = "-"
        @tuple[:email] = "-"
        @tuple[:copy_passport] = "-"
        @tuple[:copy_signature] = "-"
        @tuple[:copy_mail_addr] = "-"
      end
      
      @tuple[:contract_0] = t.contract_0_needed ? (t.contract_0? ? "O" : "X") : "-"
      @tuple[:contract_1] = t.contract_1_needed ? (t.contract_1? ? "O" : "X") : "-"
      @tuple[:contract_2] = t.contract_2_needed ? (t.contract_2? ? "O" : "X") : "-"
      @tuple[:contract_3] = t.contract_3_needed ? (t.contract_3? ? "O" : "X") : "-"
      @tuple[:contract_4] = t.contract_4_needed ? (t.contract_4? ? "O" : "X") : "-"
      @tuple[:contract_5] = t.contract_5_needed ? (t.contract_5? ? "O" : "X") : "-"
      @tuple[:contract_6] = t.contract_6_needed ? (t.contract_6? ? "O" : "X") : "-"
      @tuple[:contract_7] = t.contract_7_needed ? (t.contract_7? ? "O" : "X") : "-"
      @tuple[:contract_8] = t.contract_8? ? "O" : "X"
      
      @report.push(@tuple)
    end
    
    respond_to do |format|
      format.html
      format.xlsx do
        head_col = ["中文名字", "投資金額/幣別", "每股面額/幣別",	"股數",
          "英文名字", "護照號碼", "國籍", "中文地址", "英文地址", "email",
          "護照影本",	"簽名頁影本",	"郵寄地址影本",
          "意向書",	"Regular S", "USD合約",	"RMB合約", "購買協議", "W8BEN", "換股協議", "聲明書", "銀行水單"]
          
        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "未完成交易") do |sheet|
          sheet.add_row head_col
          @report.each do |r|
            sheet.add_row r.except(:transaction_id).values
          end
        end
 
        send_data p.to_stream.read,
          filename: @company.name_zh + "_" + "lackinfo.xlsx", 
          type: "application/xlsx"
      end
    end
  end
end
