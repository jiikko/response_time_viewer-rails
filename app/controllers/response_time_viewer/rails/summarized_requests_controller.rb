class ResponseTimeViewer::Rails::SummarizedRequestsController < ResponseTimeViewer::Rails::ApplicationController
  def index
    @search_object = ResponseTimeViewer::Rails::SearchObject.new(summarized_request_params)
    if params[:watching_url_group_id]
      watching_url_group = ResponseTimeViewer::Rails::WatchingUrlGroup.find(params[:watching_url_group_id])
      watching_url_paths = watching_url_group.watching_urls.pluck(:path)
      @search_object.set_watching_url_paths(watching_url_paths)
    end
    @paths = @search_object.path_with_summarized_requests do |path, summarized_requests|
      [ path,
        summarized_requests.page(params[:page]).per(500).order(:summarized_at),
      ]
    end
  end

  private

  def summarized_request_params
    params.fetch(:search_object, {}).permit!
  end
end
