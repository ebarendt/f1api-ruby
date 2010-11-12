require 'yaml'

module FellowshipTechAPIClient # :nodoc:
  # This accesses the YAML-based F1 API config file
  # 
  # This class was written to take rails environment variables like +RAILS_ENV+ and +Rails.root+ into account
  class Configuration
    # Gets the specified key from the configuration file
    # [Example]    FellowshipTechAPIClient.Configuration["consumer_key"] <i># "2"</i><br />
    #              FellowshipTechAPIClient.Configuration["consumer_secret"] <i># "12345678-9abc-def0-1234-567890abcdef"</i>
    def self.[](value)
      load_yaml if @config_yaml.nil?
      
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
    
    private
    
    def self.load_yaml
      if defined? ::Rails
        @config_yaml = YAML.load_file("#{::Rails.root}/config/f1-oauth.yml")
      else
        path = File.dirname(__FILE__) + "/../../config/f1-oauth.yml"
        @config_yaml = YAML.load_file(path)
      end
    end
  end
end
