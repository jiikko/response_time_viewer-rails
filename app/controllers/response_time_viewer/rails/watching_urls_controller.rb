module ResponseTimeViewer::Rails
  class WatchingUrlsController < ApplicationController
    def index
      @urls = WatchingUrl.all
    end

    def new
      @url = WatchingUrl.new
    end

    def create
      @url = WatchingUrl.new(watching_url_params)
      if @url.save
        redirect_to watching_urls_url, notice: '新規作成しました'
      else
        render :new
      end
    end

    def edit
      @url = WatchingUrl.find(params[:id])
    end

    def update
      @url = WatchingUrl.find(params[:id])
      if @url.update(watching_url_params)
        redirect_to watching_urls_url, notice: '更新しました'
      else
        render :edit
      end
    end

    private

    def watching_url_params
      params.required(:watching_url).permit(:path, :memo)
    end
  end
end
