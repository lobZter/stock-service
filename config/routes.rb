Rails.application.routes.draw do
  root 'main#index'
  get '/stocks/class', to: 'stocks#stock_class'
  resources :stockholders
  resources :companies
  resources :capital_increases
  resources :transactions
  resources :stocks
  resources :identities do 
    resources :companies
  end
  
end
