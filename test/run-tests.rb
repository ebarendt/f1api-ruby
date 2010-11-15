BASE_DIR = File.dirname(__FILE__)

require 'bundler/setup'
require 'test/unit'
require 'mocha'
require "#{BASE_DIR}/fixtures/request_token.rb"
require "#{BASE_DIR}/fixtures/access_token.rb"
require "#{BASE_DIR}/../lib/f1api-ruby"

Dir["#{BASE_DIR}/unit/*.rb"].each do |test|
  require test
end