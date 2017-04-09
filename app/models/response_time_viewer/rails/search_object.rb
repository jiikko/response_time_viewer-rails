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
    return @summarized_requests if @summarized_requests

    if device.present? && device != 'false'
      @relation.where!(device: device)
    end

    if path.present?
      @relation = @relation.like_search_by_path(path)
    end

    # @summarized_requests = @relation.order(:summarized_at)

    @summarized_requests = @relation
  end

  def series
    list = []
    summarized_requests.group_by(&:path).map do |path, summarized_requests|
      hash = {
        name: path,
        type: 'line',
        data: [],
      }
      prev_date = nil
      period.each do |current_date|
        unless prev_date
          prev_date = current_date # TODO 初回時をskipしないようにする
          next
        end
        found_data_in_period = false
        summarized_requests.each do |summarized_request|
          # 二分探索使える
          if (prev_date.to_datetime..current_date.to_datetime).include?(summarized_request.summarized_at.to_datetime)
            found_data_in_period = true
            hash[:data] << summarized_request.total_ms
            break
          end
        end
        unless found_data_in_period
          hash[:data] << 0
        end
        prev_date = current_date
      end
      list << hash
    end
    list
  end

  def period
    (self.start_on..self.end_on).flat_map do |date|
      current_date = date.beginning_of_day
      (1.day / 5.minutes).times.map { |x| current_date = current_date + 5.minutes }
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
