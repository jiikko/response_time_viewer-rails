module ResponseTimeViewer
  module Rails
    class LogDownloadService
      def self.downloaded_log_with
        service = self.new
        Metscola.summary_range = 60 * 10 * 6 # 60分
        SugoiIkoYoLogFetcherRuby.chdir_with do |tmpdir|
          service.run
          Dir.glob("#{tmpdir}/**/*.gz").each do |path|
            yield(path, path.remove("#{tmpdir}/"))
          end
        end
      end

      def run
        yesterday = Date.today - 1
        runner = SugoiIkoYoLogFetcherRuby::Runner.new(*(yesterday..Time.now.to_date).to_a)
        runner.download!(except_paths: imported_access_log_paths)
      end

      private

      def imported_access_log_paths
        ResponseTimeViewer::Rails::AccessLog.yesterday.pluck(:path)
      end
    end
  end
end
