require 'json'

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

    def transform_response(response_body, path)
      json = JSON.parse(response_body)
      if json.keys.first == "results"
        results = json["results"]["person"]
        (json["results"].keys.find_all {|key| key[0] == '@' && key != '@array'}).each do |key|
          results.each do |result|
            result.merge!({key => json["results"][key]})
          end
        end
        JSON.dump(results)
      elsif !json[json.keys.first][json.keys.first.singularize].nil?
        JSON.dump(json[json.keys.first][json.keys.first.singularize])
      else
        JSON.dump(json[json.keys.first])
      end
    end
  end
end
