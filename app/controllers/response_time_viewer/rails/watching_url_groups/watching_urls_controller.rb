module ResponseTimeViewer::Rails
  class WatchingUrlGroups::WatchingUrlsController < ApplicationController

    def index
      @watching_url_group = WatchingUrlGroup.find(params[:watching_url_group_id])
      set_variables
    end

    def create
      @watching_url_group = WatchingUrlGroup.find(params[:watching_url_group_id])
      @watching_url_group.watching_urls << WatchingUrl.find(params[:watching_url_id])
      respond_to do |format|
        format.js do
          set_variables
          @body = render_to_string('response_time_viewer/rails/watching_url_groups/watching_urls/index', layout: false)
          render :rerender
        end
        format.html do
          redirect_to @watching_url_group_watching_urls_path, notice: 'URLを登録しました'
        end
      end
    end

    def destroy
      @watching_url_group = WatchingUrlGroup.find(params[:watching_url_group_id])
      ids = @watching_url_group.watching_url_ids
      @watching_url_group.watching_url_ids = ids.delete_if { |x| x == params[:id].to_i }
      respond_to do |format|
        format.js do
          set_variables
          @body = render_to_string('response_time_viewer/rails/watching_url_groups/watching_urls/index', layout: false)
          render :rerender
        end
        format.html do
          redirect_to watching_url_group_watching_urls_path, notice: 'URLを削除しました'
        end
      end
    end

    private

    def set_variables
      @watching_urls = @watching_url_group.watching_urls.order('response_time_viewer_rails_watching_url_groups_urls.created_at asc')
      @addable_watching_urls = WatchingUrl.where.not(id: @watching_urls).
        page(params[:page]).
        per(200)
    end
  end
end
