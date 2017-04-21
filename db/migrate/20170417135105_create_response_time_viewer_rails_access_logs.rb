class CreateResponseTimeViewerRailsAccessLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :response_time_viewer_rails_access_logs do |t|
      t.string :path, null: false, limit: 191
      t.integer :status, null: false, default: 0
      t.integer :executing_time, null: false, default: 0
      t.text :error_trace

      t.timestamps
    end
  end
end
