require 'bundler/setup'
require 'oauth'
require 'base64'
require 'uri'

# The token request reponse is scoped only in the token_request method, but I need to get access to the response
# headers so that I can pull back the Content-Location header and get the authenticated user URI
OAuth::Consumer.class_eval do
  def token_request(http_method, path, token = nil, request_options = {}, *arguments)
    @tr_response = request(http_method, path, token, request_options, *arguments)
    case @tr_response.code.to_i

    when (200..299)
      if block_given?
        yield @tr_response.body
      else
        # symbolize keys
        # TODO this could be considered unexpected behavior; symbols or not?
        # TODO this also drops subsequent values from multi-valued keys
        CGI.parse(@tr_response.body).inject({}) do |h,(k,v)|
          h[k.strip.to_sym] = v.first
          h[k.strip]        = v.first
          h
        end
      end
    when (300..399)
      # this is a redirect
      @tr_response.error!
    when (400..499)
      raise OAuth::Unauthorized, @tr_response
    else
      @tr_response.error!
    end
  end
  
  def token_request_response
    @tr_response
  end
end

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
      # The URI for the resource of the authenticated user
      attr_reader :authenticated_user_uri

      # The OAuth consumer object
      attr_reader :oauth_consumer
      alias :consumer :oauth_consumer
      
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
      
      # After a the user has been authenticated then we use the access token to access protected resources in the API.
      # Since the authentication has taken place, we now know about the user that authenticated and 
      # have a URI to the record of that user.
      #
      # The URI for the authenticated user is returned.
      def get_access_token
        @oauth_access_token = oauth_request.get_access_token
        @authenticated_user_uri = oauth_consumer.token_request_response["Content-Location"]
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