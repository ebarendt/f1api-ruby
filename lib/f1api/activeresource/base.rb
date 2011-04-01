module FellowshipOneAPI # :nodoc:
  # The Base class should be inherited by all model classes as it provides the facilities that the class will need
  class Base < ActiveResource::Base
    self.site = "#{Configuration.site_url}/v1"
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

    def initialize(*args)
      template = @connection.request :get, self.site + "/" + self.class.to_s.pluralize + "/New.json"
      template = JSON.parse(template.body)
      super(args)
    end
  end
end
