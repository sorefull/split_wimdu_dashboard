require 'split'
require 'split/wimdu_dashboard'
require 'split_wimdu_dashboard/version'
require 'split_wimdu_dashboard/configuration'

module SplitWimduDashboard
  extend self
  attr_reader :configuration

  def configure
    @configuration ||= Configuration.new
    yield(configuration)
  end
end

SplitWimduDashboard.configure {}
