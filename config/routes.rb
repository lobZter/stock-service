Rails.application.routes.draw do
  root 'main#index'
  get   'login'  => 'main#login'
  post  'login'  => 'main#check_login'
  get   'logout' => 'main#logout'
  resources :stockholders
  resources :companies
  resources :capital_increases
  resources :transactions
  resources :stocks
  resources :identities do 
    resources :companies
  end
  
end
