class ResponseTimeViewer::Rails::SearchObject
  include ActiveModel::Model

  attr_accessor :device, :path

  def initialize(params)
    super(params)
    @relation = ResponseTimeViewer::Rails::SummarizedRequest.all
  end

  def add_condition!(watching_urls: )
    @relation.where!(path: watching_urls.select(:path))
  end

  def summarized_requests
    if device.present? && device != 'false'
      @relation.where!(device: device)
    end

    if path.present?
      @relation = @relation.like_search_by_path(path)
    end

    @relation.order(:summarized_at)
  end
end
