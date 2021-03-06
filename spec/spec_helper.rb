ENV['RACK_ENV'] = "test"

require 'rubygems'
require 'bundler/setup'

require 'split'
require 'ostruct'
require 'yaml'
require 'complex' if RUBY_VERSION.match(/1\.8/)

Dir['./spec/support/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.order = 'random'
  config.before(:each) do
    Split.configuration = Split::Configuration.new
    Split.redis.flushall
    @ab_user = {}
    params = nil

    SplitWimduDashboard.configure do |config|
      config.report = -> (method, action, test, user, key) do
        # NOOP
      end
    end
  end
end

def session
  @session ||= {}
end

def params
  @params ||= {}
end

def request(ua = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; de-de) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27')
  @request ||= OpenStruct.new.tap do |request|
    request.user_agent = ua
    request.ip = '192.168.1.1'
  end
end
