module FellowshipOneAPI # :nodoc:
  # This accesses the YAML-based F1 API config file
  #
  # This class was written to take rails environment variables like +RAILS_ENV+ and +Rails.root+ into account
  class Configuration
    class <<self
      # Explictly defines where the configuration file is
      def file_path=(path)
        @config_yaml = nil
        @file_path = path
      end

      # Reload the configuration file
      def reload
        load_yaml
      end

      # Gets the specified key from the configuration file
      # [Example]    FellowshipTechAPIClient.Configuration["consumer_key"] <i># "2"</i>
      #
      #              FellowshipTechAPIClient.Configuration["consumer_secret"] <i># "12345678-9abc-def0-1234-567890abcdef"</i>
      def [](value)
        load_yaml if @config_yaml.nil?
        val = @config_yaml[self.environment][value]
        # if we have the string has "{church_code}" then we'll substitute it
        if val =~ /\{church_code\}/ and value != "church_code"
          return val.gsub("{church_code}", self["church_code"]) 
        end
        return val
      end

      # Gets the current environment
      def environment
        @environment ||= "development" 
        @environment ||= ::Rails.env if defined? ::Rails
        @environment
      end

      # Set the current environment
      def environment=(env_value)
        @environment = env_value
      end

      # Overridden method_missing to facilitate a more pleasing ruby-like syntax for accessing
      # configuration values
      def method_missing(name, *args, &block)
        return self[name.to_s] unless self[name.to_s].nil?
        super
      end

      # Replace the "{church_code}" string with a custom string
      # Meant for 1st party implementations
      def url_with_church_code(church_code)
        val = @config_yaml[self.environment]["url"]
        # if we have the string has "{church_code}" then we'll substitute it
        if val =~ /\{church_code\}/ and value != "church_code"
          return val.gsub("{church_code}", church_code) 
        end
      end

      private

      # Loads the YAML file
      #
      # Starts by looking to see if file_path is defined then checks in current directory (.) and then your Rails.root and then the config 
      # directory off of the base directory of the gem
      def load_yaml
        begin
          if not @file_path.nil?
            @config_yaml = YAML.load_file(@file_path)
          elsif File.exists? "./f1-oauth.yml"
            @config_yaml = YAML.load_file("./f1-oauth.yml")
          elsif defined? ::Rails
            @config_yaml = YAML.load(ERB.new(File.read("#{::Rails.root}/config/f1-oauth.yml")).result)
          else
            path = File.dirname(__FILE__) + "/../../config/f1-oauth.yml"
            @config_yaml = YAML.load_file(path)
          end
          true
        rescue Exception => ex
          puts "There was an error: #{ex.message}"
          false
        end
      end
    end
  end
end
