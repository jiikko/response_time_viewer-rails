require 'activerecord-import'
require "activerecord-import/base"
ActiveRecord::Import.require_adapter('mysql2')

class ResponseTimeViewer::Rails::SummarizedRequest < ResponseTimeViewer::Rails::ApplicationRecord
  enum device: %i(pc sp)

  scope :like_search_by_path, ->(keyword) { where('path_with_params like ?', "#{sanitize_sql_like(keyword)}%") }
  scope :search_by_path, ->(path) { where('path_with_params = ?', path) }

  # 一度に26万件入ったが1万件ずつにわけたい
  def self.import_from_file(file)
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
      self.import(summarized_requests)
      break unless continuing_read_file
    end
  end

  def self.fetch_log_and_import
    yesterday = Date.today - 1
    SugoiIkoYoLogFetcherRuby.chdir_with do |tmpdir|
      runner = SugoiIkoYoLogFetcherRuby::Runner.new(yesterday)
      runner.download!
      paths = Metscola.run(Dir.glob("#{tmpdir}/**/*.gz"))
      paths.each do |path|
        import_from_file(File.open(path))
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
