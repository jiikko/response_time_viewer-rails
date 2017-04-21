require 'activerecord-import'
require "activerecord-import/base"
ActiveRecord::Import.require_adapter('mysql2')

class ResponseTimeViewer::Rails::SummarizedRequest < ResponseTimeViewer::Rails::ApplicationRecord
  enum device: %i(pc sp)

  scope :like_search_by_path, ->(path) { where('path_with_params like ?', "#{sanitize_sql_like(path)}%") }
  scope :search_by_path, ->(path) { where(path_with_params: path) }

  # 一度に26万件入ったが1万件ずつにわけたい
  def self.import_from_file(file_or_path)
    file =
      case file_or_path
      when String
        File.open(file_or_path)
      when File, Tempfile
        file_or_path
      else
        raise('unknown file class')
      end

    ActiveRecord::Base.connection.reconnect! # mysql との接続が切れてしまっている対策
    loop do
      summarized_requests = []
      continuing_read_file = true
      50000.times do
        line = nil
        begin
          line = file.readline
        rescue EOFError
          continuing_read_file = false
          file.close
          break
        end
        hash = JSON.parse(line)
        splited = hash['path'].split('?')
        path_without_params = splited[0] && splited[0][0..190]
        params = splited[1] && splited[1][0..190]
        summarized_requests << self.new(
          path: path_without_params,
          path_with_params: hash['path'][0..190],
          params: params,
          summarized_at: Time.parse(hash['time']),
          device: hash['user_agent'],
          merged_count: hash['merged_count'],
          total_ms: hash['total_ms'],
          view_ms: hash['mss']['Views'] || 0,
          ar_ms: hash['mss']['ActiveRecord'] || 0,
          solr_ms: hash['mss']['Solr'] || 0,
        )
      end
      self.import(summarized_requests,
                  on_duplicate_key_update: %i(path_with_params device summarized_at),
                  timestamps: false)
      break unless continuing_read_file
    end
  end

  def self.fetch_log_with
    yesterday = Date.today - 1
    # 取り込みのログはダウンロードしない
    imported_access_logs = ResponseTimeViewer::Rails::AccessLog.where(
      'created_at > ?', yesterday.beginning_of_day
    )
    Metscola.summary_range = 60 * 10 * 6 # 60分
    SugoiIkoYoLogFetcherRuby.chdir_with do |tmpdir|
      runner = SugoiIkoYoLogFetcherRuby::Runner.new(*(yesterday..Time.now.to_date).to_a)
      runner.download!(except_paths: imported_access_logs.pluck(:path))
      Dir.glob("#{tmpdir}/**/*.gz").each do |path|
        yield(path)
      end
    end
  end

  def self.fetch_log_and_import
    fetch_log_with do |log_path|
      access_log = ResponseTimeViewer::Rails::AccessLog.new(path: log_path.remove("#{tmpdir}/"))
      access_log.start_executing_time!
      begin
        self.import_from_file(
          Metscola.run(log_path)
        )
        access_log.status = ResponseTimeViewer::Rails::AccessLog.statuses[:success]
      rescue => e
        access_log.error_trace = e.backtrace.join("\n")
        access_log.status = ResponseTimeViewer::Rails::AccessLog.statuses[:failure]
      ensure
        access_log.stop_executing_time!
        access_log.create!
      end
    end
  end

  def path_with_params
    if params
      "#{path}?#{params}"
    else
      path
    end
  end
end
