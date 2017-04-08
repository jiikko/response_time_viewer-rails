class ResponseTimeViewer::Rails::SearchObject
  include ActiveModel::Model

  attr_accessor :device, :path, :start_on, :end_on

  def initialize(params)
    super(params)
    @relation = ResponseTimeViewer::Rails::SummarizedRequest.all
    reflection_form_attributes!
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

  def series
    [
      { name: 'aaaaaaaaa',
        type: 'line',
        data: [1111, 22, 22],
        color: '#00f',
      },
    ]
  end

  def period
    []
  end

  private

  def reflection_form_attributes!
    if self.start_on.nil? && self.end_on.nil?
      self.start_on = 1.week.ago
      self.end_on = Date.today
    end
    if self.start_on.is_a?(String) && self.end_on.is_a?(String)
      self.start_on = self.start_on.to_date
      self.end_on = self.end_on.to_date
    end
    @relation.where!(summarized_at: self.start_on..self.end_on)
  end
end
