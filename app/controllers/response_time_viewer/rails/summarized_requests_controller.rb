class ResponseTimeViewer::Rails::SummarizedRequestsController < ResponseTimeViewer::Rails::ApplicationController
  def index
    @search_object = ResponseTimeViewer::Rails::SearchObject.new(summarized_request_params)
    if params[:watching_url_group_id]
      watching_url_group = ResponseTimeViewer::Rails::WatchingUrlGroup.find(params[:watching_url_group_id])
      watching_url_paths = watching_url_group.watching_urls.pluck(:path)
      @search_object.set_watching_url_paths(watching_url_paths)
      @paths = watching_url_paths.map do |path|
        [
          path,
          @search_object.
            summarized_requests.
            search_by_path(path).
            page(params[:page]).
            per(500),
        ]
      end
    else
      @summarized_requests = @search_object.
        summarized_requests.
        order(:summarized_at).
        page(params[:page]).
        per(500)
    end
  end

  private

  def summarized_request_params
    params.fetch(:search_object, {}).permit!
  end
end
