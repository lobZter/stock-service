Rails.application.routes.draw do
  root 'main#index'
  get   'login'  => 'main#login'
  post  'login'  => 'main#check_login'
  get   'logout' => 'main#logout'
  get   'company_report' => 'report#company_report'
  get   'contract_report' => 'report#contract_report'
  get   'lackinfo_report' => 'report#lackinfo_report'
  get   'stockholder_archive' => 'archive#stockholder_archive'
  get   'companie_archive' => 'archive#company_archive'
  get   'transaction_archive' => 'archive#transaction_archive'
  get   'capital_increase_archive' => 'archive#capital_increase_archive'
  
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
