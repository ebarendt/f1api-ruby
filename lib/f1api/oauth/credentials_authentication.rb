module FellowshipOneAPI # :nodoc:
  module OAuth
  # Implements the Credentials method of authentication.  You must manage the credentials.
    module CredentialsAuthentication
      include OAuth
      # Authenticates a user and throws and error if unable
      # +username+::   The username of the user
      # +password+::   The password of the user
      # +type+::       Can be :portal or :weblink based on which credentials you want to authenticate against
      # Returns the URI for the authenticated user
      def authenticate!(username, password, type = :portal)
        response = get_api_response(username, password, type)

        handle_response_code(response)
        # Gettting the URI of the authenticated user
        @authenticated_user_uri = response["Content-Location"]
      end
      alias :authorize! :authenticate!

      # Authenticates a user and returns true if successful
      # +username+::   The username of the user
      # +password+::   The password of the user
      # +type+::       Can be :portal or :weblink based on which credentials you want to authenticate against
      # Returns _true_ if was able to authenticate, _false_ if not
      def authenticate(username, password, type = :portal)
        response = get_api_response(username, password, type)

        if(response.code.to_i == 400)
          return false
        end
        handle_response_code(response)
        return true
      end
      alias :authorize :authenticate

      private
     def handle_response_code(response)
        case response.code.to_i
        when (200..299)
          @oauth_access_token = ::OAuth::AccessToken.from_hash(@oauth_consumer, parse_access_token(response.body))
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

      def get_api_response(username, password, type)
        load_consumer_config(type) if @oauth_consumer.nil?

        cred = URI.encode(Base64.encode64("#{username} #{password}"))

        case type
        when :portal
          auth_url = FellowshipOneAPI::Configuration.portal_credential_token_path
        when :weblink
          auth_url = FellowshipOneAPI::Configuration.weblink_credential_token_path
        end

        @oauth_consumer.request(:post, auth_url, nil, {}, "ec=#{cred}", {'Content-Type' => 'application/x-www-form-urlencoded'})
      end

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
