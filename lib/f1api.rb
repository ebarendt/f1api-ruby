module FellowshipOneAPI
  class <<self
    attr_accessor :consumer_key, :consumer_secret, :site_url, :church_code,
      :authentication_type, :request_token_path, :access_token_path, :portal_authorize_path,
      :weblink_authorize_path, :portal_credential_token_path, :weblink_credential_token_path,
      :config_file_path, :environment

    def configure
      yield self
      environment ||= :development

      load_values_from_yml_file
      true
    end

    private
    def load_values_from_yml_file
      return unless config_file_path
      y = File.read(File.expand_path(config_file_path))

      config = y[environment.to_s]
      config.each do |k, v|
        send(k.to_sym, v)
      end
    end
  end
end
