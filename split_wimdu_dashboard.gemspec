# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'split_wimdu_dashboard/version'

Gem::Specification.new do |spec|
  spec.name          = 'split_wimdu_dashboard'
  spec.version       = SplitWimduDashboard::VERSION
  spec.authors       = ['Hugo Duksis']
  spec.email         = ['duksis@gmail.com']
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'split', '>= 0.7.2'
  spec.add_dependency 'sinatra', '>= 1.2.6'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rack-test', '>= 0.5.7'
end
