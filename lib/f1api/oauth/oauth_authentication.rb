module FellowshipOneAPI # :nodoc:
  module OAuth
    # Implements the pure OAuth method of authentication.  This allows the Fellowship One API to 
    # manage the authentication process.
    module OAuthAuthentication
      include OAuth
      # The OAuth request object
      attr_reader :oauth_request

      # The OAuth authorization URI
      attr_reader :oauth_authorize_url
      alias :authorize_url :oauth_authorize_url

      # Gets a new request token and return the authenticated URI
      # +type+:: Can be :portal or :weblink based on which credentials you want to authenticate against
      def authenticate!(type = :portal)
        load_consumer_config(type) if oauth_consumer.nil?

        @oauth_request = oauth_consumer.get_request_token
        @oauth_authorize_url = oauth_request.authorize_url

        @oauth_consumer.instance_eval do
          # The token request reponse is scoped only in the token_request method, but I need to get access to the response
          # headers so that I can pull back the Content-Location header and get the authenticated user URI
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

          # The HTTP response from token_request
          def token_request_response
            @tr_response
          end
        end

        oauth_authorize_url
      end
      alias :authorize! :authenticate!

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
  end
end
