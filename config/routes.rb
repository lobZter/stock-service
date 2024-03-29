Rails.application.routes.draw do
  
  devise_for :users
  root  'main#index'
  get   'login'  => 'main#login'
  post  'login'  => 'main#check_login'
  get   'logout' => 'main#logout'
  get   'company_report' => 'report#company_report'
  get   'contract_report' => 'report#contract_report'
  get   'lackinfo_report' => 'report#lackinfo_report'
  
  resources :stockholders do
    get 'archive', on: :collection
  end
  
  resources :companies do
    get 'archive', on: :collection
    resources :stocks, only: [:index]
  end
  
  resources :capital_increases, except: [:show] do
    get 'archive', on: :collection
  end
  
  resources :transactions, except: [:show] do
    get 'archive', on: :collection
  end
  
  resources :identities do
    resources :stocks, only: [:index]
  end
  
end
