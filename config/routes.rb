Rails.application.routes.draw do
  root 'main#index'
  resources :stockholders
  resources :companies
  resources :capital_increases
  resources :transactions
  resources :stocks
end
