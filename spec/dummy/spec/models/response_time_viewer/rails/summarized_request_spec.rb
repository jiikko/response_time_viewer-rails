require 'rails_helper'

describe ResponseTimeViewer::Rails::SummarizedRequest do
  describe '.fetch_log_and_import' do
    before(:each) do
      ResponseTimeViewer::Rails::AccessLog.delete_all
      allow(ResponseTimeViewer::Rails::LogDownloadService).to receive(:downloaded_log_with).and_yield('/tmp/foo.log', 'foo.log')
      expect_any_instance_of(ResponseTimeViewer::Rails::AccessLog).to receive(:stop_executing_time!).once
    end
    describe '正常系' do
      context 'ログの集計が成功する時' do
        it 'AccessLogレコードを作成してstatusがsuccessであること' do
          file = Tempfile.new
          allow(ResponseTimeViewer::Rails::SummarizedRequest).to receive(:summarize_log).and_return(file.path)
          ResponseTimeViewer::Rails::SummarizedRequest.fetch_log_and_import
          records = ResponseTimeViewer::Rails::AccessLog.where(path: 'foo.log')
          expect(records.count).to eq(1)
          access_log = records.first
          expect(access_log.status).to eq('success')
          expect(access_log.error_trace).to eq(nil)
          file.close
        end
      end
    end
    describe '異常系' do
      context 'ログの集計が失敗する時' do
        it 'AccessLogレコードを作成してstatusがfailureであること' do
          allow(ResponseTimeViewer::Rails::SummarizedRequest).to receive(:summarize_log).and_return(nil)
          ResponseTimeViewer::Rails::SummarizedRequest.fetch_log_and_import
          records = ResponseTimeViewer::Rails::AccessLog.where(path: 'foo.log')
          expect(records.count).to eq(1)
          access_log = records.first
          expect(access_log.status).to eq('failure')
          expect(access_log.error_trace).not_to eq(nil)
        end
      end
    end
  end

  describe '.import_from_file' do
    context '入力ファイルが 1 行あるとき' do
      it '1 レコード作成すること' do
        begin
          file = Tempfile.new
          body = <<-EOH
{"total_ms":202.0,"mss":{"Views":62.3,"ActiveRecord":60.5,"Solr":8.3},"time":"2017-03-22 02:43:25 +0900","method":"GET","user_agent":"sp","path":"/events?page=2&prefecture_ids%5B%5D=10","merged_count":0}
          EOH
          file.write(body) && file.seek(0)
          ResponseTimeViewer::Rails::SummarizedRequest.import_from_file(file.path)
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
          ResponseTimeViewer::Rails::SummarizedRequest.import_from_file(file.path)
          expect(ResponseTimeViewer::Rails::SummarizedRequest.count).to eq(3)
        ensure
          file.close
        end
        ResponseTimeViewer::Rails::SummarizedRequest.destroy_all
      end
    end
  end
end
