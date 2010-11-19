require 'nokogiri'

module FellowshipOneAPI
  # Creating a wrapper for the ActiveResource::Connection class
  class Connection < ActiveResource::Connection
    # Pass in a new connection to the API
    def initialize(f1api_connection, *args)
      @f1api_connection = f1api_connection
      super(*args)
    end
    
    private
    # The request method that is passes the request through to the F1 API client
    def request(method, path, *args)
      if @f1api_connection == nil
        super(method, path, *args)
      else
        response = @f1api_connection.request(method, path, *args)
        
        if method == :get
          response.body = transform_response response.body, path
        end
        handle_response(response)
      end
    end
    
    # 
    def transform_response(response_body, path)
      n = Nokogiri::XML(response_body)
      res = (n/"results")
      if not (res.empty?)
        resource = ((path.split '/')[2]).downcase
        res[0].name = resource
      end
      
      n.to_s
    end
  end
end