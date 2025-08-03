Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # get 'products/index'
      # get 'products/create'
      resources :transactions, only: [:index, :create]
      resources :accounts, only: [:index, :create]
      resources :categories, only: [:index, :create]
      resources :products, only: [:index, :create]
    end
  end
end