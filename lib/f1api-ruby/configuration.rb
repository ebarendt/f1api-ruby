module FellowshipOneAPI # :nodoc:
  # This accesses the YAML-based F1 API config file
  # 
  # This class was written to take rails environment variables like +RAILS_ENV+ and +Rails.root+ into account
  class Configuration
    # Explictly defines where the configuration file is
    def self.file_path=(path)
      @file_path
    end
    
    # Gets the specified key from the configuration file
    # [Example]    FellowshipTechAPIClient.Configuration["consumer_key"] <i># "2"</i><br />
    #              FellowshipTechAPIClient.Configuration["consumer_secret"] <i># "12345678-9abc-def0-1234-567890abcdef"</i>
    def self.[](value)
      load_yaml if @config_yaml.nil?
      val = @config_yaml[self.environment][value]
      # if we have the string has "{church_code}" then we'll substitute it
      if val =~ /\{church_code\}/ and value != "church_code"
        return val.gsub("{church_code}", self["church_code"]) 
      end
      return val
    end
    
    # Gets the current environment
    def self.environment
      @environment ||= "development" 
      @environment ||= ::Rails.env if defined? ::Rails
      @environment
    end
    
    # Set the current environment
    def self.environment=(env_value)
      @environment = env_value
    end
    
    # Overridden method_missing to facilitate a more pleasing ruby-like syntax for accessing
    # configuration values
    def self.method_missing(name, *args, &block)
      return self[name.to_s] unless self[name.to_s].nil?
      super
    end
    
    private
    
    # Loads the YAML file
    #
    # Starts by looking to see if file_path is defined then checks in current directory (.) and then your Rails.root and then the config 
    # directory off of the base directory of the gem
    def self.load_yaml
      if not @file_path.nil?
        @config_yaml = YAML.load_file(@file_path)
      elsif File.exists? "./f1-oauth.yml"
        @config_yaml = YAML.load_file("./f1-oauth.yml")
      elsif defined? ::Rails
        @config_yaml = YAML.load_file("#{::Rails.root}/config/f1-oauth.yml")
      else
        path = File.dirname(__FILE__) + "/../../config/f1-oauth.yml"
        @config_yaml = YAML.load_file(path)
      end
    end
  end
end
