class CreateResponseTimeViewerRailsWatchingUrlGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :response_time_viewer_rails_watching_url_groups do |t|
      t.string :name, null: false
      t.integer :watching_url, null: false
      t.index :watching_url, name: :index_watching_url_groups_watching_url

      t.timestamps
    end
  end
end
