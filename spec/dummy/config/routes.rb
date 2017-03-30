Rails.application.routes.draw do
  mount ResponseTimeViewer::Rails::Engine => "/response_time_viewer-rails"
end
