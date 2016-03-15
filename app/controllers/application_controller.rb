class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :is_login, :except => [:login, :check_login] 
  before_action :is_admin
  protected
  def is_login    
    if not session[:is_login]
      redirect_to controller: 'main', action: 'login'
    end
  end
  
  def is_admin
    if session[:is_login] and not session[:is_admin]
      user_allow_action = ["index", "show"]
      if !user_allow_action.include?params[:action]
        redirect_to controller: 'main', action: 'index'
      end
    end
  end
end
