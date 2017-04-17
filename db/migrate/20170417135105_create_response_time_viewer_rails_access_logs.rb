class CreateResponseTimeViewerRailsAccessLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :response_time_viewer_rails_access_logs do |t|
      t.string :path, null: false
      t.index :path, unique: true
      t.index :created_at

      t.timestamps
    end
  end
end
