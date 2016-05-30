class CompaniesController < ApplicationController
  before_action :set_company, :only => [:show, :edit, :update]
  before_action :set_data, :only => [:new, :edit]

  def create
    @company = Company.new(company_params)
    
    if @company.save
      
      # Create staffs
      staff_params[:stockholder_id].length.times do |i|
        Staff.create(:company_id => @company.id,
          :stockholder_id => staff_params[:stockholder_id][i],
          :job_title => staff_params[:job_title][i])
      end
      
      # Create identities
      @identity = Identity.create(:company_id => @company.id, :stockholder_id => nil)
      
      # Update identity_id
      @company.identity_id = @identity.id
      @company.save
      
      # Create capital increase
      @capital_increase = CapitalIncrease.create(
        :identity_id => @identity.id,
        :stock_class => @company.stock_class,
        :date_issued => @company.date_establish,
        :fund => @company.fund,
        :currency => @company.currency,
        :stock_price => @company.stock_price,
        :stock_num => @company.stock_num,
        :remark => "起始增資",
        :stock_checked => false,
        :is_first => true
      )
      redirect_to company_path(@company)
    else
      set_data()
      render :action => :new
    end
  end
  
  def new
    @company = Company.new
    @staffs = Staff.new
    @company.staffs.build
  end
  
  def edit
  end
  
  def show
    @currency_array = [nil, "USD 美金", "RMB 人民幣", "NTD 新台幣"]
    @identity = @company.identity
    @stocks = @identity.stock_show
    @transactions = @identity.recent_transactions
    @capital_increases = @identity.recent_capital_increase
    @staffs = Staff.where("company_id=?", @company.id)
  end
  
  def update
    @company = Company.find(params[:id])
    if @company.update(company_params)
      redirect_to company_path(@company)
    else
      set_data()
      if @company.errors.messages.value?(["股票已變動, 無法更動起始資金資訊"])
        flash.now[:errors] = "股票已變動, 無法更動起始資金資訊"
      end
      render :action => :edit
    end
  end

  
  private
  def set_company
    @company = Company.find(params[:id])
  end
  
  def set_data
    @stockholders = Stockholder.all
    @currency_array = Currency.types
    @company_hash = {
      'Chinese' => :name_zh,
      'English' => :name_en,
      'Ein'     => :ein,
      'Phone'   => :phone,
      'Address' => :address }
    @staff_hashes = [
      'Chairan' => {'name' => :chairman_name, 'passport' => :chairman_passport, 'email' => :chairman_email},
      'CEO' => {'name' => :ceo_name, 'passport' => :ceo_passport, 'email' => :ceo_email},
      'CFO' => {'name' => :cfo_name, 'passport' => :cfo_passport, 'email' => :cfo_email}]
    @bank_hashes = [
      {'title'=> '匯款帳戶資訊 - 美金',
       'bank' => :us_account_bank,
       'num'  => :us_account_num,
       'name' => :us_account_name,
       'address' => :us_account_bank_addr},
      {'title'=> '匯款帳戶資訊 - 人民幣',
       'bank' => :cn_account_bank,
       'num'  => :cn_account_num,
       'name' => :cn_account_name,
       'address' => :cn_account_bank_addr},
      {'title'=> '匯款帳戶資訊 - 台幣',
       'bank' => :tw_account_bank,
       'num'  => :tw_account_num,
       'name' => :tw_account_name,
       'address' => :tw_account_bank_addr}]
  end
    
  def company_params
    params.require(:company).permit(:name_zh, :name_en, :ein, :phone, :address,
      :date_establish, :date_accounting, :fund, :currency, :stock_class, :stock_price, :stock_num,
      :us_account_bank, :us_account_num, :us_account_name, :us_account_bank_addr,
      :cn_account_bank, :cn_account_num, :cn_account_name, :cn_account_bank_addr,
      :tw_account_bank, :tw_account_num, :tw_account_name, :tw_account_bank_addr)
  end
  def staff_params
    params.require(:staff).permit({stockholder_id: []}, {job_title: []})
  end
 
end
