module ResponseTimeViewer::Rails
  class AccessLog < ApplicationRecord
    enum status: %i(success failure)

    def start_executing_time!
      @start_executing_time = Time.now
    end

    def stop_executing_time!
      self.executing_time = Time.now - @start_executing_time
    end
  end
end
