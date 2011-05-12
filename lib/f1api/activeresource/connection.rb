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
        case method
        when :get
          response = @f1api_connection.request(method, path, *args)
          response.body = transform_get_response response.body
        when :put
          response = transform_put_request path, args[0]
        when :post
          response = transform_create_request path, args[0]
        end
        puts response.to_hash.inspect
        handle_response(response)
      end
    end

    def transform_create_request(path, request_body)
      new_path = "#{path}/new.json"
      new_record = @f1api_connection.request :get, new_path
      merged_entity = JSON.parse(new_record)
      new_values = JSON.parse(request_body)
      new_values.each do |k,v|
        merged_entity[self.class.name.downcase][k] = v
      end
      puts JSON.dump(merged_entity)
      @f1api_connection.request(:post, path, JSON.dump(merged_entity), {'Content-Type' => 'application/json'})
    end

    def transform_put_request(path, request_body)
      edit_path = path.gsub(/(.*)\.json$/, '\1/edit.json')
      edit_record = @f1api_connection.request :get, edit_path
      merged_entity = JSON.parse(edit_record.body)
      new_values = JSON.parse(request_body)
      entity_type = merged_entity.keys.first
      new_values[entity_type].each do |k,v|
        if merged_entity[entity_type][k].is_a? Hash
          merged_entity[entity_type][k] = v[v.keys.first]
        else
          merged_entity[entity_type][k] = v
        end
      end
      if path =~ /\/[vV]1\/(.*)\/(.*)$/
        new_path = "/V1/#{$1.capitalize}/#{$2}"
      end
      puts JSON.dump(merged_entity)
      @f1api_connection.request(:put, new_path, JSON.dump(merged_entity), {'Content-Type' => 'application/json'})
    end

    def transform_get_response(response_body)
      json = JSON.parse(response_body)
      if json.keys.first == "results"
        results = json["results"][self.class.name.downcase]
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
