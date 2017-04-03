class CreateResponseTimeViewerRailsSummarizedRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :response_time_viewer_rails_summarized_requests do |t|
      t.string :path, null: false, limit: 191
      t.string :params, null: false, limit: 191
      t.datetime :summarized_at, nul: false
      t.integer :device, null: false
      t.integer :merged_count, null: false
      t.integer :total_ms, null: false, default: 0
      t.integer :view_ms, null: false, default: 0
      t.integer :ar_ms, null: false, default: 0
      t.integer :solr_ms, null: false, default: 0

      t.timestamps null: false
    end
  end
end
