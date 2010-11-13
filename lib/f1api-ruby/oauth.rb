require 'oauth'

module FellowshipOneAPIClient # :nodoc:
  # Wrapper around the OAuth v1.0 specification using the +oauth+ gem.
  module OAuth
    Configuration = ::FellowshipOneAPIClient::Configuration
    # This will get a new request token and return the authorize url
    def authorize!
      @consumer = ::OAuth::Consumer.new(Configuration.consumer_key, Configuration.consumer_secret,
                  { :site => Configuration.site_url,
                    :request_token_path => Configuration.request_token_path,
                    :access_token_path => Configuration.access_token_path,
                    :authorize_path => Configuration.portal_authorize_path})
    end
  end
end
    