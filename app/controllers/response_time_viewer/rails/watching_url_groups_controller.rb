module ResponseTimeViewer::Rails
  class WatchingUrlGroupsController < ApplicationController
    def index
      @groups = WatchingUrlGroup.all
    end

    def new
      @group = WatchingUrlGroup.new
    end

    def create
      @group = WatchingUrlGroup.new(watching_url_group_params)
      if @group.save
        redirect_to watching_urls_url, notice: '新規作成しました'
      else
        render :new
      end
    end

    def edit
      @group = WatchingUrlGroup.find(params[:id])
    end

    def update
      @group = WatchingUrlGroup.find(params[:id])
      if @group.update(watching_url_group_params)
        redirect_to watching_urls_url, notice: '更新しました'
      else
        render :edit
      end
    end

    private

    def watching_url_group_params
      params.required(:watching_url_group).permit(:name, :memo)
    end
  end
end
