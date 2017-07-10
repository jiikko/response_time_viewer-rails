class CreateResponseTimeViewerRailsWatchingUrls < ActiveRecord::Migration[5.0]
  def change
    create_table :response_time_viewer_rails_watching_urls do |t|
      t.string :path, null: false, limit: 191
      t.index :path, unique: true

      t.timestamps
    end
  end
end
