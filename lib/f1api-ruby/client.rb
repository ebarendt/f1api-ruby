module FellowshipOneAPI
  class Client
    def initialize(args = {})
      if args[:auth_type] == :credentials
        extend OAuth::CredentialsAuthentication
      else
        extend OAuth::OAuthAuthentication
      end
    end
  end
end