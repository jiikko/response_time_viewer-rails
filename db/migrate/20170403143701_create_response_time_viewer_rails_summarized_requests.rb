class CreateResponseTimeViewerRailsSummarizedRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :response_time_viewer_rails_summarized_requests do |t|
      t.string :path, null: false, limit: 191
      t.string :params, limit: 191
      t.datetime :summarized_at, nul: false
      t.integer :device, null: false
      t.integer :merged_count, null: false
      t.float :total_ms, null: false, default: 0
      t.float :view_ms, null: false, default: 0
      t.float :ar_ms, null: false, default: 0
      t.float :solr_ms, null: false, default: 0
      t.index [:summarized_at, :path], name: :index_summarized_requests_summarized_at_path

      t.timestamps null: false
    end
  end
end
