require 'bundler/setup'
require 'test/unit'
require 'mocha'

require "#{File.dirname(__FILE__)}/../fixtures/request_token.rb"
require "#{File.dirname(__FILE__)}/../fixtures/access_token.rb"
require "#{File.dirname(__FILE__)}/../../lib/f1api-ruby/oauth.rb"
require "#{File.dirname(__FILE__)}/../../lib/f1api-ruby/configuration.rb"

class OAuthAuthenticationTest
  include FellowshipOneAPI::OAuth::OAuthAuthentication
  attr_accessor :oauth_consumer
end

class OAuthTest < Test::Unit::TestCase
  include FellowshipOneAPI
  def setup
    Configuration.environment = "test"
    Configuration.file_path = "#{File.dirname(__FILE__)}/../../config/f1-oauth.yml"
    
    @oauth_test = OAuthAuthenticationTest.new
    @oauth_test.load_consumer_config
    @mocked_request_token = RequestTokenFixture.get(@oauth_test.oauth_consumer)
    @mocked_access_token = AccessTokenFixture.get(@oauth_test.oauth_consumer)
    @oauth_test.oauth_consumer.stubs(:get_request_token).returns(@mocked_request_token)
  end
  
  def test_portal_authorize!
    @oauth_test.oauth_consumer.expects(:get_request_token).returns(@mocked_request_token)
    @oauth_test.authorize!
    
    assert_equal("request", @oauth_test.oauth_request.token)
    assert_equal("token", @oauth_test.oauth_request.secret)
    assert_equal("#{Configuration.site_url}#{Configuration.portal_authorize_path}?oauth_token=#{@oauth_test.oauth_request.token}", @oauth_test.authorize_url)
  end
  
  def test_weblink_authorize!
    @oauth_test.oauth_consumer = nil
    @oauth_test.load_consumer_config(:weblink)
    @mocked_request_token = RequestTokenFixture.get(@oauth_test.oauth_consumer)
    @oauth_test.oauth_consumer.expects(:get_request_token).returns(@mocked_request_token)
    
    @oauth_test.authorize!(:weblink)
    
    assert_equal("request", @oauth_test.oauth_request.token)
    assert_equal("token", @oauth_test.oauth_request.secret)
    assert_equal("#{Configuration.site_url}#{Configuration.weblink_authorize_path}?oauth_token=#{@oauth_test.oauth_request.token}", @oauth_test.authorize_url)
  end
  
  def test_get_access_token
    @oauth_test.authorize!
    
    @oauth_test.oauth_request.expects(:get_access_token).returns(@mocked_access_token)
    @oauth_test.oauth_consumer.expects(:token_request_response).returns({"Content-Location" => ""})
    @oauth_test.get_access_token
    
    assert_equal("access", @oauth_test.access_token.token)
    assert_equal("token", @oauth_test.access_token.secret)
  end
  
  def test_authorized_user_uri
    mocked_user_uri = "#{Configuration.site_url}/V1/People/123456"
    
    @oauth_test.authorize!
    
    @oauth_test.oauth_request.expects(:get_access_token).returns(@mocked_access_token)
    @oauth_test.oauth_consumer.expects(:token_request_response).returns({"Content-Location" => mocked_user_uri})
    @oauth_test.get_access_token
    
    assert_equal(mocked_user_uri, @oauth_test.authenticated_user_uri)
  end
  
  def test_change_auth_types
    @oauth_test.authorize!
    assert_equal("#{Configuration.site_url}#{Configuration.portal_authorize_path}", @oauth_test.oauth_consumer.authorize_url)
    @oauth_test.load_consumer_config(:weblink)
    @oauth_test.oauth_consumer.stubs(:get_request_token).returns(@mocked_request_token)
    @oauth_test.authorize!
    assert_equal("#{Configuration.site_url}#{Configuration.weblink_authorize_path}", @oauth_test.oauth_consumer.authorize_url)
  end
  
end