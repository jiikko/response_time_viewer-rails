class CreateResponseTimeViewerRailsWatchingUrlGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :response_time_viewer_rails_watching_url_groups do |t|
      t.string :name, null: false
      t.integer :watchi_urls_counter, null: false, default: 0
      t.text :memo

      t.timestamps
    end
  end
end
