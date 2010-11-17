require 'hpricot'

module FellowshipOneAPI
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
        h = response.body
        if method == :get
          res = (h.get_elements_by_tag_name("results")[0])
          if not res.nil?
            resource = ((path.split '/')[2]).downcase
            response.body = h.to_s
          end
        end
        handle_response(response)
      end
    end
  end
end