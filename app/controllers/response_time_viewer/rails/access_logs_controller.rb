module ResponseTimeViewer::Rails
  class AccessLogsController < ApplicationController
    def index
      @access_logs = AccessLog.page(params[:page]).per(300).order(id: :desc)
    end
  end
end
