class ResponseTimeViewer::Rails::SearchObject
  include ActiveModel::Model

  attr_accessor \
    :device,
    :full_match_path_with_params,
    :like_match_path_with_params,
    :start_on,
    :end_on,
    :like_search,
    :total_ms_over_limit,
    :total_ms_under_limit,
    :solr_ms_over_limit,
    :solr_ms_under_limit,
    :ac_ms_over_limit,
    :ac_ms_under_limit,
    :view_ms_over_limit,
    :view_ms_under_limit,
    :show_agv,
    :show_pagination

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
    if full_match_path_with_params.present?
      @relation = @relation.search_by_path(full_match_path_with_params)
    end
    if like_match_path_with_params.present?
      @relation = @relation.like_search_by_path(like_match_path_with_params)
    end

    @relation.where!('total_ms > ?', total_ms_over_limit) if total_ms_over_limit.present?
    @relation.where!('total_ms < ?', total_ms_under_limit) if total_ms_under_limit.present?
    @relation.where!('solr_ms > ?', solr_ms_over_limit) if solr_ms_over_limit.present?
    @relation.where!('solr_ms < ?', solr_ms_under_limit) if solr_ms_under_limit.present?
    @relation.where!('ac_ms > ?', ac_ms_over_limit) if ac_ms_over_limit.present?
    @relation.where!('ac_ms < ?', ac_ms_under_limit) if ac_ms_under_limit.present?
    @relation.where!('view_ms > ?', view_ms_over_limit) if view_ms_over_limit.present?
    @relation.where!('view_ms < ?', view_ms_under_limit) if view_ms_under_limit.present?
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
