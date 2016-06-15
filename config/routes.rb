Rails.application.routes.draw do
  root 'main#index'
  get   'login'  => 'main#login'
  post  'login'  => 'main#check_login'
  get   'logout' => 'main#logout'
  get   'company_report' => 'report#company_report'
  get   'contract_report' => 'report#contract_report'
  get   'lackinfo_report' => 'report#lackinfo_report'
  resources :stockholders, except: [:destory]
  resources :companies, except: [:destory, :index]
  resources :companies do
    resources :stocks, only: [:index]
  end
  resources :capital_increases, except: [:show]
  resources :transactions, except: [:show]
  resources :identities do 
    resources :stocks, only: [:index]
  end
  
end
