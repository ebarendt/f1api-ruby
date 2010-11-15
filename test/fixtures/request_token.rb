require 'bundler/setup'
require 'oauth'

class RequestTokenFixture
  def self.get(oauth_consumer)
    @token = "request"
    @secret = "token"
    return ::OAuth::RequestToken.new(oauth_consumer, @token, @secret)
  end
end