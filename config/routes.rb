Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants/search#find'
      get '/merchants/find_all', to: 'merchants/search#find_all'
      get '/merchants/random', to: 'merchants/random#show'
      resources :merchants, only: [:index, :show]
    end
  end
end
