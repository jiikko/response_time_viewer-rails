class CreateResponseTimeViewerRailsWatchingUrlGroupsWatchingUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :response_time_viewer_rails_watching_url_groups_urls, id: false do |t|
      t.integer :watching_url_group_id
      t.integer :watching_url_id
      t.index [:watching_url_group_id, :watching_url_id], unique: true, name: :index_watching_url_group_id_watching_url_id

      t.timestamps
    end
  end
end
