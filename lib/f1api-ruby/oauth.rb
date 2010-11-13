require 'bundler/setup'
require 'oauth'
require 'base64'
require 'uri'

OAuth::Consumer.

module FellowshipOneAPIClient # :nodoc:
  # Wrapper around the OAuth v1.0 specification using the +oauth+ gem.
  #
  # The Fellowship One API has two methods of authentication:
  # [OAuthAuthentication]       This is the default method if no method is declared.  This method allows Fellowship Tech to handle
  #                             the authentication and we redirect back to your app.
  # [CredentialsAuthentication]  The methods lets the consumer submit credentials and verify authentication.
  module OAuth
    # Implements the pure OAuth method of authentication.  This allows the Fellowship One API to 
    # manage the authentication process.
    module OAuthAuthentication
      # The OAuth consumer object
      attr_reader :oauth_consmer
      
      # The OAuth request object
      attr_reader :oauth_request
      
      # The OAuth authorization URI
      attr_reader :oauth_authorize_url
      alias :authorize_url :oauth_authorize_url
      
      # The OAuth access token object where all requests are made off of
      attr_reader :oauth_access_token
      alias :access_token :oauth_access_token
      
      # Gets a new request token and return the authorize URI
      def authorize!
        @oauth_consumer = ::OAuth::Consumer.new(::FellowshipOneAPIClient::Configuration.consumer_key, 
                          ::FellowshipOneAPIClient::Configuration.consumer_secret,
                          {:site => ::FellowshipOneAPIClient::Configuration.site_url,
                           :request_token_path => ::FellowshipOneAPIClient::Configuration.request_token_path,
                           :access_token_path => ::FellowshipOneAPIClient::Configuration.access_token_path,
                           :authorize_path => ::FellowshipOneAPIClient::Configuration.portal_authorize_path})
        @oauth_request = consumer.get_request_token
        @oauth_authorize_url = oauth_request.authorize_url
      end
      
      def get_access_token
        @oauth_access_token = oauth_requeset.get_access_token
      end
    end
    
    # Implements the Credentials method of authentication.
    # ++
    # TODO: Implement this and document
    # --
    module CredentialsAuthentication
      def authorize!
        
      end
    end
  end
end