module SplitWimduDashboard
  class ActivityReporter
    SAFE_METHODS = %w{GET HEAD}

    def initialize(env)
      @env = env
    end

    def report
      SplitWimduDashboard.configuration.report.(
        method, action, test, current_user, key
      )
    end

    private
    attr_reader :env

    def key
      [:ab_test, test.to_sym, action.to_sym]
    end

    def test
      path.match(/\/([a-zA-Z_-]*)$/) {|m| m[1]}
    end

    def action
      if method == 'DELETE'
        method.downcase
      else
        path.match(/^\/admin\/split\/([a-z]*)\/(.*)/) {|m| m[1]} || 'stop'
      end
    end

    def method
      @_method ||= env['REQUEST_METHOD']
    end

    def current_user
      @_current_user ||= env['warden'].user
    end

    def path
      @_path ||= env['REQUEST_PATH']
    end
  end
end
