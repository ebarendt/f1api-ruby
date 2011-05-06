module FellowshipOneAPI # :nodoc:
  # The Base class should be inherited by all model classes as it provides the facilities that the class will need
  class Base < ActiveResource::Base
    # Creates a new connection
    #
    # ==Examples
    #   Person.connect(FellowshipOneAPI::Client.new)
    #
    # If the connection needs to be forcibly refreshed then you can pass true
    #   Person.connect(FellowshipOneAPI::Client.new, true)
    def self.connect(client, refresh = false)
      if(refresh or @connection.nil?)
        @connection = Connection.new(client, client.consumer.site, format)
      end
    end

    # Setting site from configuration
    self.site = "#{FellowshipOneAPI::Configuration.site_url}/v1"
    # Setting mode to JSON
    self.format = :json
  end
end
