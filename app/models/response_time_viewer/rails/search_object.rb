class ResponseTimeViewer::Rails::SearchObject
  include ActiveModel::Model

  attr_accessor :device, :path, :start_on, :end_on, :like_search

  def initialize(params)
    super(params)
    @relation = ResponseTimeViewer::Rails::SummarizedRequest.all
    reflection_form_attributes!
  end

  def set_watching_url_paths(watching_url_paths)
    @watching_url_paths = watching_url_paths
  end

  def summarized_requests
    return @summarized_requests if @summarized_requests

    if device.present? && device != 'false'
      @relation.where!(device: device)
    end
    if path.present?
      @relation = @relation.search_by_path(path)
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
    path_with_summarized_requests do |path, summarized_requests|
      hash = {}
      hash[:name] = path
      hash[:data] = summarized_requests.
        limit(500).
        pluck(:summarized_at,:total_ms)
      list << hash
    end
    list
  end

  def path_with_summarized_requests
    if @watching_url_paths.blank?
      return [yield('all', summarized_requests)]
    end

    @watching_url_paths.map do |path|
      local_summarized_requests =
        if like_search.present? && like_search == '1'
          summarized_requests.like_search_by_path(path)
        else
          summarized_requests.search_by_path(path)
        end
      yield(path, local_summarized_requests)
    end
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
