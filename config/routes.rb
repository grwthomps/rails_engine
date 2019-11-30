Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/find', to: 'search#find'
        get '/find_all', to: 'search#find_all'
        get '/random', to: 'random#show'
        get '/:id/items', to: 'items#index'
        get '/:id/invoices', to: 'invoices#index'
        get '/most_revenue', to: 'revenue#highest_total_revenue'
        get '/revenue', to: 'revenue#total_revenue'
      end
      resources :merchants, only: [:index, :show]
      namespace :customers do
        get '/find', to: 'search#find'
        get '/find_all', to: 'search#find_all'
        get '/random', to: 'random#show'
      end
      resources :customers, only: [:index, :show]
      namespace :invoices do
        get '/find', to: 'search#find'
        get '/find_all', to: 'search#find_all'
        get '/random', to: 'random#show'
      end
      resources :invoices, only: [:index, :show]
    end
  end
end
