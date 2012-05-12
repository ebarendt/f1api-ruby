require 'f1api/client'

module FellowshipOneAPI
  class <<self
    attr_accessor :consumer_key, :consumer_secret, :site_url, :church_code,
      :request_token_path, :access_token_path, :portal_authorize_path,
      :weblink_authorize_path, :portal_credential_token_path, :weblink_credential_token_path,
      :config_file_path, :environment

    attr_writer :authentication_type

    def configure
      yield self if block_given?
      self.environment ||= :development

      load_values_from_yml_file
      true
    end

    def authentication_type
      @authentication_type || :oauth
    end

    private
    def load_values_from_yml_file
      return unless config_file_path
      y = File.read(File.expand_path(config_file_path))

      y = YAML.load(y)
      config = y[self.environment.to_s]
      config.each do |k, v|
        if send(k.to_sym).nil?
          send("#{k}=".to_sym, v)
        end
      end
    end
  end
end
