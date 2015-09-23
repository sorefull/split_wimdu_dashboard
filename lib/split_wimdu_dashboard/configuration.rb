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
      return @report if @report

      raise NotImplementedError, REPORT_NOT_IMPLEMENTED_MESSAGE
    end

    private

    REPORT_NOT_IMPLEMENTED_MESSAGE = <<-MESSAGE
[NOTE] It's your turn to implement the logic.

== Example

config.report = ->(method, action, test, user, key) do
  return if SplitWimduDashboard::ActivityReporter::SAFE_METHODS.include?(method)

  DataHub::Logger.log("AB test \#{test} was \#{action}ed by \#{user.email}", key)
  DataHub::Metrics.increment(key.join('.'))
end
    MESSAGE
  end
end
