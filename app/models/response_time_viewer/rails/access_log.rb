module ResponseTimeViewer::Rails
  class AccessLog < ApplicationRecord
    enum status: %i(downloaded success failure_summarize failure_import)

    scope :yesterday, ->() {
      yesterday = Date.today - 1
      where('created_at > ?', yesterday.beginning_of_day)
    }

    def stop_executing_time!
      if executing_time.present?
        self.executing_time = Time.now - executing_time
      end
    end
  end
end
