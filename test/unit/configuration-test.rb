require 'test/unit'
require 'mocha'
require "#{File.dirname(__FILE__)}/../../lib/f1api-ruby/configuration.rb"

class OAuthTest < Test::Unit::TestCase
  include FellowshipOneAPIClient
  
  def setup
    Configuration.environment = "test"
    Configuration.file_path = "#{File.dirname(__FILE__)}/../../config/f1-oauth.yml"
  end
  
  def test_method_missing
    assert_raise NoMethodError do 
      Configuration.asdf
    end
    
    assert_nothing_raised do
      Configuration.consumer_key
    end
    
    assert_equal Configuration["consumer_key"], Configuration.consumer_key
  end
  
  def test_consumer_key
    assert_equal("123456789", Configuration.consumer_key)
  end
  
  def test_consumer_secret
    assert_equal("12345678-90ab-cdef-0123-4567890abcde", Configuration.consumer_secret)
  end
  
  def test_site_url
    assert_equal("https://test.staging.fellowshiponeapi.com", Configuration.site_url)
  end
  
  def test_church_code
    assert_equal("test", Configuration.church_code)
  end
  
  def test_request_token_path
    assert_equal("/V1/Tokens/RequestToken", Configuration.request_token_path)
  end
  
  def test_access_token_path
    assert_equal("/V1/Tokens/AccessToken", Configuration.access_token_path)
  end
  
  def test_portal_authorize_path
    assert_equal("/V1/PortalUser/Login", Configuration.portal_authorize_path)
  end
  
  def test_weblink_authorize_path
    assert_equal("/V1/WeblinkUser/Login", Configuration.weblink_authorize_path)
  end
  
  def test_portal_credential_token_path
    assert_equal("/V1/PortalUser/AccessToken", Configuration.portal_credential_token_path)
  end
  
  def test_weblink_credential_token_path
    assert_equal("/V1/WeblinkUser/AccessToken", Configuration.weblink_credential_token_path)
  end
end