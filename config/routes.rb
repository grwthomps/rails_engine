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
        get '/:id/invoices', to: 'invoices#index'
        get '/:id/transactions', to: 'transactions#index'
      end
      resources :customers, only: [:index, :show]
      namespace :invoices do
        get '/find', to: 'search#find'
        get '/find_all', to: 'search#find_all'
        get '/random', to: 'random#show'
        get '/:id/transactions', to: 'transactions#index'
        get '/:id/invoice_items', to: 'invoice_items#index'
        get '/:id/items', to: 'items#index'
        get '/:id/customer', to: 'customers#show'
        get '/:id/merchant', to: 'merchants#show'
      end
      resources :invoices, only: [:index, :show]
      namespace :items do
        get '/find', to: 'search#find'
        get '/find_all', to: 'search#find_all'
        get '/random', to: 'random#show'
        get '/:id/invoice_items', to: 'invoice_items#index'
        get '/:id/merchant', to: 'merchants#show'
      end
      resources :items, only: [:index, :show]
      namespace :transactions do
        get '/find', to: 'search#find'
        get '/find_all', to: 'search#find_all'
        get '/random', to: 'random#show'
        get '/:id/invoice', to: 'invoices#show'
      end
      resources :transactions, only: [:index, :show]
      namespace :invoice_items do
        get '/find', to: 'search#find'
        get '/find_all', to: 'search#find_all'
        get '/random', to: 'random#show'
        get '/:id/invoice', to: 'invoices#show'
        get '/:id/item', to: 'items#show'
      end
      resources :invoice_items, only: [:index, :show]
    end
  end
end
