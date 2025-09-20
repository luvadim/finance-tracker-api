Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # get 'products/index'
      # get 'products/create'
      resources :transactions, only: [:index, :create]
      resources :accounts, only: [:index, :create]
      resources :categories, only: [:index, :create]
      resources :products, only: [:index, :create]
      resources :users, only: [:index]
      
      put 'users/set_current_account', to: 'users#set_current_account'
    end
  end
end