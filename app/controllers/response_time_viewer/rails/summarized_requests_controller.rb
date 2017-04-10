class ResponseTimeViewer::Rails::SummarizedRequestsController < ResponseTimeViewer::Rails::ApplicationController
  def index
    @search_object = ResponseTimeViewer::Rails::SearchObject.new(summarized_request_params)
    if params[:watching_url_group_id]
      watching_url_group = ResponseTimeViewer::Rails::WatchingUrlGroup.find(params[:watching_url_group_id])
      watching_urls = watching_url_group.watching_urls
      @search_object.add_condition!(watching_urls: watching_urls)
    end
    @summarized_requests = @search_object.
      summarized_requests.
      order(:summarized_at).
      page(params[:page]).
      per(200)
  end

  private

  def summarized_request_params
    params.fetch(:search_object, {}).permit!
  end
end
