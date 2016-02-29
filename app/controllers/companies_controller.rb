class CompaniesController < ApplicationController
    def new
        @company = Company.new
        @company_hash = {'Chinese' => :name_zh,
                        'English' => :name_en,
                        'Ein'     => :ein,
                        'Phone'   => :phone,
                        'Address' => :address }
        @staff_hashes = ['Chairan' => {'name' => :chairman_name, 'passport' => :chairman_passport, 'email' => :chairman_email},
                       'CEO' => {'name' => :ceo_name, 'passport' => :ceo_passport, 'email' => :ceo_email},
                       'CFO' => {'name' => :cfo_name, 'passport' => :cfo_passport, 'email' => :cfo_email}]
        @bank_hashes = [{'title'=> '匯款帳戶資訊 - 美金',
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
end
