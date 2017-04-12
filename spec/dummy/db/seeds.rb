ResponseTimeViewer::Rails::WatchingUrl.destroy_all
ResponseTimeViewer::Rails::SummarizedRequest.group(:path_with_params).count.sort_by { |x, v| - v }.map { |x, v| x }.first(100).each do |path|
  ResponseTimeViewer::Rails::WatchingUrl.create!(path: path)
end
