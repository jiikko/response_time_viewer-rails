ResponseTimeViewer::Rails::Engine.routes.draw do
  root 'top#index'
  resources :summarized_requests, only: :index
  resources :watching_url_groups
  resources :watching_urls
end
