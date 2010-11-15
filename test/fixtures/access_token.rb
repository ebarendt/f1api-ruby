require 'bundler/setup'
require 'oauth'

class AccessTokenFixture
  def self.get(oauth_consumer)
    @token = "access"
    @secret = "token"
    return ::OAuth::AccessToken.new(oauth_consumer, @token, @secret)
  end
end