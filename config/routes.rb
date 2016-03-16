Rails.application.routes.draw do
  root 'main#index'
  get   'login'  => 'main#login'
  post  'login'  => 'main#check_login'
  get   'logout' => 'main#logout'
  resources :stockholders, except: [:destory]
  resources :companies, except: [:destory, :index]
  resources :capital_increases, except: [:show]
  resources :transactions, except: [:show]
  resources :identities do 
    resources :stocks, only: [:index]
  end
  
end
