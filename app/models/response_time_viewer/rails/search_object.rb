class ResponseTimeViewer::Rails::SearchObject
  include ActiveModel::Model

  attr_accessor :device, :path, :start_on, :end_on, :full_match_path

  def initialize(params)
    super(params)
    @relation = ResponseTimeViewer::Rails::SummarizedRequest.all
    reflection_form_attributes!
  end

  def set_watching_urls_condition(watching_urls: )
    @watching_url_paths = watching_urls.pluck(:path)
  end

  def summarized_requests
    return @summarized_requests if @summarized_requests

    if device.present? && device != 'false'
      @relation.where!(device: device)
    end
    if path.present?
      @relation = @relation.like_search_by_path(path)
    end
    if path.blank? && full_match_path.present?
      @relation = @relation.search_by_path(full_match_path)
    end
    @summarized_requests = @relation
  end

  def period
    (self.start_on..self.end_on).flat_map do |date|
      current_date = date.beginning_of_day
      (1.day / 5.minutes).times.map { |x| current_date = current_date + 5.minutes }
    end
  end

  def chart_data
    list = []
    @watching_url_paths.map do |path|
      hash = {}
      hash[:name] = path
      hash[:data] = summarized_requests.
        where(path: path).
        limit(500).
        map { |x| [x.summarized_at, x.total_ms] }
      list << hash
    end
    list
  end

  private

  def reflection_form_attributes!
    if self.start_on.nil? && self.end_on.nil?
      self.start_on = 1.week.ago.to_date
      self.end_on = Date.today
    end
    if self.start_on.is_a?(String) && self.end_on.is_a?(String)
      self.start_on = self.start_on.to_date
      self.end_on = self.end_on.to_date
    end
    @relation.where!(summarized_at: self.start_on..self.end_on)
  end
end
