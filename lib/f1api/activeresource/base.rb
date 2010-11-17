module FellowshipOneAPI # :nodoc:
  # The Base class should be inherited by all model classes as it provides the facilities that the class will need
  class Base
    def initialize
      @@client = Client.new({:auth_type => Configuration.authentication_type.to_sym}) if @@client.nil?
      @uri = "/v1/#{self.class.to_s}"
    end
    
    def find(*args)
      if args[0].integer?
        get_single_record(args[0])
      end
    end
    
    def list
      @xml = @@client.get "#{@uri}"
    end
    
    def search(params)
      url_params = ""
      params.each do |param|
        url_params += "#{param[0]}=#{URI.encode(param[1])}&"
      end
      url_params[-1] = ''
      
      @xml = @@client.get "#{@uri}/search?#{url_params}"
    end
    
    def show(id)
      @xml = @@client.get "#{@uri}/#{id}"
    end
  end
end