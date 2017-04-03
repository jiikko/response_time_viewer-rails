Rails.application.routes.draw do
  mount ResponseTimeViewer::Rails::Engine => "/response_time_viewer", as: :response_time_viewer
  get 'response_time_viewer' => 'response_time_viewer#index'
end
