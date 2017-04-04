class ResponseTimeViewer::Rails::SummarizedRequestsController < ResponseTimeViewer::Rails::ApplicationController
  def index
    @search_object = ResponseTimeViewer::Rails::SearchObject.new(summarized_request_params)
    @summarized_requests = @search_object.
      summarized_requests.
      page(params[:page]).
      per(200)
  end

  private

  def summarized_request_params
    params.fetch(:search_object, {}).permit!
  end
end
