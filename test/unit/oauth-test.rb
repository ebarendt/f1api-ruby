require 'test/unit'
require 'mocha'
require "#{File.dirname(__FILE__)}/../../lib/f1api-ruby/oauth.rb"

class OAuthTest < Test::Unit::TestCase
  include FellowshipOneAPIClient
  def setup
    Configuration.environment = "test"
    Configuration.file_path = "#{File.dirname(__FILE__)}/../../config/f1-oauth.yml"
  end