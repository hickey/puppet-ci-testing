Gem::Specification.new do |s|
  s.name            = 'puppet-ci-testing'
  s.version         = '0.12.6.pre'
  s.date            = '2016-04-27'
  s.summary         = ''
  s.description     = ''
  s.authors         = ["Gerard Hickey"]
  s.email           = 'hickey@kinetic-compute.com'
  s.add_runtime_dependency 'puppet', '>= 3.2.0'
  s.add_runtime_dependency 'colorize'
  s.add_runtime_dependency 'puppet-lint', '>= 1.1.0'
  s.add_runtime_dependency 'rspec-puppet', '>= 2.0.0'
  s.add_runtime_dependency 'rspec-puppet-utils', '>= 3.1.0'
  s.add_runtime_dependency 'puppetlabs_spec_helper', '>= 0.8.0'
  s.add_runtime_dependency 'deep_merge'
  s.add_runtime_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'rake', '~> 11.3.0'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake-version', '~> 1.0'
  s.add_development_dependency 'fakefs', '~> 0.10.0'
  s.platform        = Gem::Platform::RUBY
  s.require_paths   = [ 'lib' ]
  s.files           = Dir['lib/*'] + Dir['etc/*'] + Dir['spec/*']
  s.executables     = ['check_file_syntax', 'puppet_unittest_workflow']
  s.homepage        = 'https://github.com/hickey/puppet-ci-testing/'
end
