class MainController < ApplicationController
    before_action :has_login, :except => [:login, :check_login] 
    
    def login
        @show_error = params["show_error"]
    end
    
    def check_login
        puts params
        if params["account"] == "admin" and params["password"] == "00000000"
            session[:name] = "admin"
            session[:is_admin] = true
            session[:is_login] = true
            redirect_to controller: 'main', action: 'index'    
        elsif params["account"] == "employee" and params["password"] == "12345678"
            session[:name] = "employee"
            session[:is_admin] = false
            session[:is_login] = true
            redirect_to controller: 'main', action: 'index'    
        else
            redirect_to controller: 'main', action: 'login', show_error: true    
        end
    end
    
    def logout
        reset_session
        redirect_to controller: 'main', action: 'login'
    end
    
    def index
        @companies = Company.all
        @stockholders = Stockholder.all
    end

    protected
    
    def has_login    
        if not session[:is_login]
            puts "nononono" 
            redirect_to controller: 'main', action: 'login'
        end
    end
end
