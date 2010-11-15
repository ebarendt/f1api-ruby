require 'bundler/setup'
require 'oauth'
require 'base64'
require 'uri'

module FellowshipOneAPI # :nodoc:
  # Wrapper around the OAuth v1.0 specification using the +oauth+ gem.
  #
  # The Fellowship One API has two methods of authentication:
  # [OAuthAuthentication]       This is the default method if no method is declared.  This method allows Fellowship Tech to handle
  #                             the authentication and we redirect back to your app.
  # [CredentialsAuthentication]  The methods lets the consumer submit credentials and verify authentication.
  module OAuth
    # The OAuth consumer key.
    # This will get set automatically from the YAML config file if not set explictly
    attr_accessor :oauth_consumer_key
    alias :consumer_key :oauth_consumer_key
    alias :consumer_key= :oauth_consumer_key=
    
    # The OAuth consumer secret.
    # This will get set automatically from the YAML config file if not set explictly
    attr_accessor :oauth_consumer_secret
    alias :consumer_secret :oauth_consumer_secret
    alias :consumer_secret= :oauth_consumer_secret=
     
    # The OAuth access token object where all requests are made off of
    attr_reader :oauth_access_token
    alias :access_token :oauth_access_token
    
    # The OAuth consumer object
    attr_reader :oauth_consumer
    alias :consumer :oauth_consumer
    
    # The URI for the resource of the authenticated user
    attr_reader :authenticated_user_uri
    
    # Creates the OAuth consumer object
    def load_consumer_config(type = :portal)
      case type
      when :portal
        authorize_path = ::FellowshipOneAPI::Configuration.portal_authorize_path
      when :weblink
        authorize_path = ::FellowshipOneAPI::Configuration.weblink_authorize_path
      end
      
      @oauth_consumer_key ||= ::FellowshipOneAPI::Configuration.consumer_key
      @oauth_consumer_secret ||= ::FellowshipOneAPI::Configuration.consumer_secret
      
      @oauth_consumer = ::OAuth::Consumer.new(@oauth_consumer_key, 
                        @oauth_consumer_secret,
                        {:site => ::FellowshipOneAPI::Configuration.site_url,
                         :request_token_path => ::FellowshipOneAPI::Configuration.request_token_path,
                         :access_token_path => ::FellowshipOneAPI::Configuration.access_token_path,
                         :authorize_path => authorize_path })
    end
    
    # Implements the pure OAuth method of authentication.  This allows the Fellowship One API to 
    # manage the authentication process.
    module OAuthAuthentication
      include OAuth
      
      # The OAuth request object
      attr_reader :oauth_request
      
      # The OAuth authorization URI
      attr_reader :oauth_authorize_url
      alias :authorize_url :oauth_authorize_url
      
      # Gets a new request token and return the authorize URI
      # +type+:: Can be :portal or :weblink based on which credentials you want to authenticate against
      def authorize!(type = :portal)
        load_consumer_config(type) if oauth_consumer.nil?
        
        @oauth_request = oauth_consumer.get_request_token
        @oauth_authorize_url = oauth_request.authorize_url
        # The token request reponse is scoped only in the token_request method, but I need to get access to the response
        # headers so that I can pull back the Content-Location header and get the authenticated user URI
        @oauth_consumer.instance_eval do
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
    
    # Implements the Credentials method of authentication.  You must manage the credentials.
    module CredentialsAuthentication
      include OAuth
      # Authorizes a user 
      # +username+::   The username of the user
      # +password+::   The password of the user
      # +type+::       Can be :portal or :weblink based on which credentials you want to authenticate against
      def authorize!(username, password, type = :portal)
        load_consumer_config(type)
        
        @oauth_request = @oauth_consumer.get_request_token
        cred = URI.encode(Base64.encode64("#{username} #{password}"))
        
        case type
        when :portal
          auth_url = ::FellowshipOneAPI::Configuration.portal_credential_token_path
        when :weblink
          auth_url = ::FellowshipOneAPI::Configuration.weblink_credential_token_path
        end
        
        response = oauth_consumer.request(:post, auth_url, nil, {}, "ec=#{cred}", {'Content-Type' => 'application/x-www-form-urlencoded'})
        case response.code.to_i
          
        when (200..299)
          @oauth_access_token = ::OAuth::AccessToken.from_hash(@oauth_consumer, parse_access_token(response.body))
          response.body
        when (300..399)
          # redirect
          # TODO: actually redirect instead of throwing error
          response.error!
        when (400..499)
          raise OAuth::Unauthorized, response
        else
          response.error!
        end

      end
      
      private
      # Parse returned OAuth access token key/secret pair
      def parse_access_token(response)
        oauth_hash = {}
        response.split('&').each do |val|
          kv = val.split('=')
          oauth_hash.merge!({kv[0].to_sym => kv[1]})
        end
        oauth_hash
      end
    end
  end
end