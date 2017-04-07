class ResponseTimeViewer::Rails::SearchObject
  include ActiveModel::Model

  attr_accessor :device, :path

  def initialize(params)
    super(params)
  end

  def summarized_requests
    relation = ResponseTimeViewer::Rails::SummarizedRequest.all
    if device != 'false' || !device
      relation.where!(device: device)
    end

    if path.present?
      relation = relation.like_search_by_path(path)
    end

    relation.order(:summarized_at)
  end
end
