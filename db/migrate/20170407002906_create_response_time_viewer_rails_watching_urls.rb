class CreateResponseTimeViewerRailsWatchingUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :response_time_viewer_rails_watching_urls do |t|
      t.string :path, null: false

      t.timestamps
    end
  end
end
