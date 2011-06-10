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

    def id
      self.attributes["@id"]
    end

    def new?
      self.attributes["@id"].nil?
    end

    # Setting site from configuration
    self.site = "#{FellowshipOneAPI::Configuration.site_url}/v1"
    # Setting mode to JSON
    self.format = :json

    self.include_root_in_json = false

    private

    def find_or_create_resource_for(name)
      resource_name = name.to_s.camelize
      ancestors = self.class.name.split("::")
      if ancestors.size > 1
        find_resource_in_modules(resource_name, ancestors)
      else
        self.class.const_get(resource_name)
      end
    rescue NameError
      if self.class.const_defined?(resource_name)
        resource = self.class.const_get(resource_name)
      else
        resource = self.class.const_set(resource_name, Class.new(FellowshipOneAPI::Base))
      end
      resource.prefix = self.class.prefix
      resource.site   = self.class.site
      resource
    end

  end
end
