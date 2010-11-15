module FellowshipOneAPI
  class Client
    def initialize(args = {})
      if args[:auth_type] == :credentials
        extend OAuth::CredentialsAuthentication
      else
        extend OAuth::OAuthAuthentication
      end
    end
    
    def get(*args)
      @oauth_access_token.get(*args)
    end
  end
end