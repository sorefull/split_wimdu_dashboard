module SplitWimduDashboard
  require 'split_wimdu_dashboard/activity_reporter'
  class Configuration
    attr_writer :reporter, :report

    def reporter
      @reporter ||= -> rack_env {
        ActivityReporter.new(rack_env).report
      }
    end

    def report
      @report ||= -> method, action, test, user, key {
        # return if ActivityReporter::SAFE_METHODS.include?(method)

        # DataHub::Logger.log("AB test #{test} was #{action}ed by #{user.email}", key)
        # DataHub::Metrics.increment(key.join('.'))
      }
    end
  end
end
