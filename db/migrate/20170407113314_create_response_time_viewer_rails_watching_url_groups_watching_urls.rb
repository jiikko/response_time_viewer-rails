class CreateResponseTimeViewerRailsWatchingUrlGroupsWatchingUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :response_time_viewer_rails_watching_url_groups_urls, id: false do |t|
      t.integer :watching_url_group_id
      t.integer :watching_url_id
    end
  end
end
