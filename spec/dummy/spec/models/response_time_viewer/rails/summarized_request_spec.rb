require 'rails_helper'

describe ResponseTimeViewer::Rails::SummarizedRequest do
  describe '.import_from_file' do
    context '入力ファイルが 1 行あるとき' do
      it '1 レコード作成すること' do
        begin
          file = Tempfile.new
          body = <<-EOH
{"total_ms":202.0,"mss":{"Views":62.3,"ActiveRecord":60.5,"Solr":8.3},"time":"2017-03-22 02:43:25 +0900","method":"GET","user_agent":"sp","path":"/events?page=2&prefecture_ids%5B%5D=10","merged_count":0}
          EOH
          file.write(body) && file.seek(0)
          ResponseTimeViewer::Rails::SummarizedRequest.import_from_file(file)
          expect(ResponseTimeViewer::Rails::SummarizedRequest.count).to eq(1)
          summarized_request = ResponseTimeViewer::Rails::SummarizedRequest.first
          expect(summarized_request.total_ms).to eq(202.0)
          expect(summarized_request.view_ms).to eq(62.3)
          expect(summarized_request.ar_ms).to eq(60.5)
          expect(summarized_request.solr_ms).to eq(8.3)
          expect(summarized_request.device).to eq('sp')
          expect(summarized_request.merged_count).to eq(0)
          expect(summarized_request.summarized_at).to eq('2017-03-22 02:43:25 +0900'.to_time)
          expect(summarized_request.path).to eq('/events')
          expect(summarized_request.params).to eq('page=2&prefecture_ids%5B%5D=10')
        ensure
          file.close
        end
        ResponseTimeViewer::Rails::SummarizedRequest.destroy_all
      end
    end
    context '入力ファイルが 3 行あるとき' do
      it '3 レコード作成すること' do
        begin
          file = Tempfile.new
          body = <<-EOH
{"total_ms":247.0,"mss":{"Views":71.3,"ActiveRecord":90.5,"Solr":12.3},"time":"2017-03-22 02:43:24 +0900","method":"GET","user_agent":"sp","path":"/facilities?age_ids%5B%5D=4&prefecture_ids%5B%5D=27","merged_count":0}
{"total_ms":376.0,"mss":{"Views":219.6,"ActiveRecord":141.1,"Solr":0.0},"time":"2017-03-22 02:43:25 +0900","method":"GET","user_agent":"sp","path":"/facilities/61217","merged_count":0}
{"total_ms":202.0,"mss":{"Views":62.3,"ActiveRecord":60.5,"Solr":8.3},"time":"2017-03-22 02:43:25 +0900","method":"GET","user_agent":"sp","path":"/events?page=2&prefecture_ids%5B%5D=10","merged_count":0}
          EOH
          file.write(body) && file.seek(0)
          ResponseTimeViewer::Rails::SummarizedRequest.import_from_file(file)
          expect(ResponseTimeViewer::Rails::SummarizedRequest.count).to eq(3)
        ensure
          file.close
        end
        ResponseTimeViewer::Rails::SummarizedRequest.destroy_all
      end
    end
  end
end
