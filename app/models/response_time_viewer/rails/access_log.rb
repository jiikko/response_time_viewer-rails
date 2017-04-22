module ResponseTimeViewer::Rails
  class AccessLog < ApplicationRecord
    enum status: %i(success failure)

    scope :yesterday, ->() {
      yesterday = Date.today - 1
      where('created_at > ?', yesterday.beginning_of_day)
    }

    def start_executing_time!
      @start_executing_time = Time.now
    end

    def stop_executing_time!
      self.executing_time = Time.now - @start_executing_time
    end
  end
end
