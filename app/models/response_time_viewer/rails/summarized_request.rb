class ResponseTimeViewer::Rails::SummarizedRequest < ApplicationRecord
  enum device: %i(pc sp)

  scope :search_by_path, ->(keyword) { where('path like ?', "#{sanitize_sql_like(keyword)}%") }

  # bulk insert
  def self.import(file)
    file.each_line do |line|
      hash = JSON.parse(line)
      splited = hash['path'].split('?')
      path_without_params = splited[0] && splited[0][0..190]
      params = splited[1] && splited[1][0..190]
      self.create!(
        path: path_without_params,
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
  end

  def path_with_params
    if params
    "#{path}?#{params}"
    else
      path
    end
  end
end
