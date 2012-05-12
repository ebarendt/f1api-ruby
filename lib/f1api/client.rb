require 'json'

module FellowshipOneAPI
  # ==The Fellowship One API client class
  # Takes an HTTP request and passes it through the OAuth library which added the approperiate headers and querystring
  # parameters.
  # ===Examples
  # [Simple client using OAuth and default YAML config values]
  #     client = FellowshipOneAPI::Client.new
  #
  #     client.authorize!
  #
  #     client.request(:get, '/v1/People/123.xml')
  #
  # [Using credentials based authentication (2nd party)]
  #     client = FellowshipOneAPI::Client.new({:auth_type => :credentials})
  #
  #     client.authorize!("username", "password")
  #
  #     client.request(:get, '/v1/People/123.xml')
  #
  # [Authenticating against weblink passing credentials]
  #     client = FellowshipOneAPI::Client.new({:auth_type => :credentials, :auth_against => :weblink})
  #
  #     client.authorize("weblinkuser", "weblinkpassword")
  #
  #     client.request(:get, '/v1/People/123.xml')
  #
  # [Loading a client with an existing access token]
  #     client = FellowshipOneAPI::Client.new({:oauth_token => "123456", :oauth_token_secret => "987654"})
  #
  #     client.request(:get, '/v1/People/123.xml')
  class Client
    # Creates a new instance of a client used to connect with the Fellowship One API
    # The client can be configured with the following symbols:
    # [+:auth_type+] - Can be _:credentials_ or _:oauth_ (_:oauth_ is the default)
    # [+:auth_against+] - Can be _:portal_ or _:weblink_ (_:portal_ is the default)
    # [+:oauth_token+] - The access token
    # [+:oauth_token_secret+] - The access token secret
    def initialize(args = {})
      args[:auth_type] ||= FellowshipOneAPI.authentication_type.to_sym
      if args[:auth_type] == :credentials
        require "#{File.dirname(__FILE__)}/oauth/credentials_authentication"
        extend OAuth::CredentialsAuthentication
      else
        require "#{File.dirname(__FILE__)}/oauth/oauth_authentication"
        extend OAuth::OAuthAuthentication
      end

      if(args[:auth_against])
        load_consumer_config args[:auth_against], args[:site_url]
      else
        load_consumer_config :portal, args[:site_url]
      end

      if(args[:oauth_token] and args[:oauth_token_secret])
        @oauth_access_token = ::OAuth::AccessToken.from_hash(@oauth_consumer, args[:oauth_token], args[:oauth_token_secret])
      end

      if(args[:auth_username] and args[:auth_password])
        authorize! args[:auth_username], args[:auth_password]
      end
    end

    # Lazy loads the user record you've logged in as
    def current_user
      if @current_user.nil?
        req = request(:get, "#{@authenticated_user_uri}.json")
        if req.code.to_i == 200
          @current_user = JSON.parse(req.body)["person"]
        else
          raise "Non HTTP 200 on current_user load"
        end
      end
      @current_user
    end

    # Passes through the request to the OAuth library to be signed and set out HTTP
    def request(*args)
      @oauth_access_token.request(*args)
    end
  end
end
