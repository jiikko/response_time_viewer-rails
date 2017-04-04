module ResponseTimeViewer::Rails
  class SummarizedRequest < ApplicationRecord
    enum device: %i(pc sp)

    def self.import(file)
      file.each_line do |line|
        hash = JSON.parse(line)
        splited = hash['path'].split('?')
        path_without_params = splited[0]
        params = splited[1]
        self.create!(
          path: path_without_params,
          params: params,
          summarized_at: Time.parse(hash['time']),
          device: hash['user_agent'],
          merged_count: hash['merged_count'],
          total_ms: hash['total_ms'],
          view_ms: hash['mss']['Views'],
          ar_ms: hash['mss']['ActiveRecord'],
          solr_ms: hash['mss']['Solr'],
        )
      end
    end
  end
end
