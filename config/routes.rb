ResponseTimeViewer::Rails::Engine.routes.draw do
  root 'top#index'
  resources :summarized_requests, only: :index
  resources :watching_urls
  resources :watching_url_groups do
    resources :summarized_requests, only: :index
    resources :watching_urls, only: %i(index create destroy), controller: 'watching_url_groups/watching_urls'
  end
  resources :access_logs, only: %i(index destroy)
end
