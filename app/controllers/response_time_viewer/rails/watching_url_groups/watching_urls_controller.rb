module ResponseTimeViewer::Rails
  class WatchingUrlGroups::WatchingUrlsController < ApplicationController
    def index
      @watching_url_group = WatchingUrlGroup.find(params[:watching_url_group_id])
      @watching_urls = @watching_url_group.watching_urls
      @addable_watching_urls = WatchingUrl.where.not(id: @watching_urls)
    end

    def create
      watching_url_group = WatchingUrlGroup.find(params[:watching_url_group_id])
      watching_url_group.watching_urls << WatchingUrl.find(params[:watching_url_id])
      redirect_to watching_url_group_watching_urls_path, notice: 'URLを登録しました'
    end

    def destroy
      watching_url_group = WatchingUrlGroup.find(params[:watching_url_group_id])
      ids = watching_url_group.watching_url_ids
      watching_url_group.watching_url_ids = ids.delete_if { |x| x == params[:watching_url_id].to_i }
      redirect_to watching_url_group_watching_urls_path, notice: 'URLを削除しました'
    end
  end
end
