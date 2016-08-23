class CompaniesController < ApplicationController
  before_action :set_company, :only => [:show, :edit, :update]
  before_action :set_data, :only => [:new, :edit]

  def index
    if params[:id]
      # GET /companies?id=#
      redirect_to company_path(Company.find(params[:id]))
    else
      @companies = Company.not_deleted
    end
  end

  def create
    @company = Company.new(company_params)
    
    if @company.save
      
      # Create staffs
      if check_staff_params
        staff_params[:stockholder_id].length.times do |i|
          if not staff_params[:job_title][i].blank?
            Staff.create(:company_id => @company.id,
              :stockholder_id => staff_params[:stockholder_id][i],
              :job_title => staff_params[:job_title][i])
          end
        end
      end
      
      # Create identities
      @identity = Identity.create(:company_id => @company.id, :stockholder_id => nil)
      
      # Update identity_id
      @company.update({:identity_id => @identity.id})
      
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
        :is_first => true)
      
      redirect_to company_path(@company)
    else
      @staffs = Array.new
      staff_params[:stockholder_id].length.times do |i|
        @staff = Staff.new({
          :stockholder_id => staff_params[:stockholder_id][i],
          :job_title => staff_params[:job_title][i]})
        @staffs.push(@staff)
      end
      
      # set flash by error messages
      @capital_increase.errors.messages.each do |key, msg|
        flash.now[key] = msg.first
      end
      
      set_data()
      render :action => :new
    end
  end
  
  def new
    @company = Company.new
  end
  
  def edit
    @staffs = Staff.where("company_id=?", @company.id)
  end
  
  def show
    @stocks = @company.identity.stock_show
    @transactions = @company.identity.recent_transactions
    @capital_increases = @company.identity.recent_capital_increase
    @staffs = Staff.where("company_id=?", @company.id)
    @stock_percentage = @company.stock_percentage
  end
  
  def update
    if @company.update(company_params)
      if check_staff_params
        Staff.where("company_id=?", @company.id).destroy_all
        
        staff_params[:stockholder_id].length.times do |i|
          if(staff_params[:job_title][i] != "")
            Staff.create(:company_id => @company.id,
              :stockholder_id => staff_params[:stockholder_id][i],
              :job_title => staff_params[:job_title][i])
          end
        end
      end
      
      redirect_to company_path(@company)
    else
      @staffs = Array.new
      staff_params[:stockholder_id].length.times do |i|
        @staff = Staff.new({
          :stockholder_id => staff_params[:stockholder_id][i],
          :job_title => staff_params[:job_title][i]})
        @staffs.push(@staff)
      end
      
      # set flash by error messages
      @capital_increase.errors.messages.each do |key, msg|
        flash.now[key] = msg.first
      end
      
      set_data()
      render :action => :edit
    end
  end
  
  # 封存
  def destroy
  end

  
  private
  def set_company
    @company = Company.find(params[:id])
  end
  
  def set_data
    @stockholders = Stockholder.all
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
    params.require(:company).permit!
  end
  
  def staff_params
    params.permit(:staff)
  end
  
  def check_staff_params
    # no staff
    if staff_params.empty?
      return false
    end
    
    if staff_params[:stockholder_id].length != staff_params[:job_title].length
      return false
    end
    
    return true
  end
 
end
