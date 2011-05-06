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

