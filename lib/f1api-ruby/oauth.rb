require 'oauth'

module FellowshipTechAPIClient # :nodoc:
  # Wrapper around the OAuth v1.0 specification using the +oauth+ gem.
  module OAuth
    # This will get a new request token and return the authorize url
    def authorize!
      @consumer = OAuth::Consumer.new
    end
  end
end
    