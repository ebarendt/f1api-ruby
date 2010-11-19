BASE_DIR = File.dirname(__FILE__)

task :test do
  require 'bundler/setup'
  require 'test/unit'
  require 'mocha'
  require "#{BASE_DIR}/test/fixtures/request_token.rb"
  require "#{BASE_DIR}/test/fixtures/access_token.rb"
  require "#{BASE_DIR}/test/fixtures/http.rb"
  require "#{BASE_DIR}/lib/f1api"
  Dir["#{BASE_DIR}/test/unit/*.rb"].each do |test|
    require test
  end
end

task :rdoc do
  `rdoc -x 'test/*'`
end

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "f1api"
  gem.homepage = "http://github.com/jessedearing/f1api"
  gem.license = "MIT"
  gem.summary = %Q{Consume the Fellowship One API in your apps using ActiveResource}
  gem.description = %Q{Consumes the Fellowship One API in your apps using ActiveResource.  Implements 2nd party credentials-based authenticaion and full OAuth implementation. }
  gem.email = "jdearing@fellowshiptech.com"
  gem.authors = ["Jesse Dearing"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
  gem.add_runtime_dependency 'oauth', '= 0.4.4'
  gem.add_development_dependency 'mocha'
  gem.add_runtime_dependency 'activeresource'
end
Jeweler::RubygemsDotOrgTasks.new