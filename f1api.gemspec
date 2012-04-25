# -*- encoding: utf-8 -*-
require File.expand_path('../lib/f1api/version', __FILE__)

Gem::Specification.new do |s|
  s.name = %q{f1api}
  s.version = FellowshipOneAPI::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jesse Dearing"]
  s.date = Time.now.strftime("%Y-%m-%d")
  s.description = %q{Consumes the Fellowship One API in your apps using ActiveResource.  Implements 2nd party credentials-based authenticaion and full OAuth implementation. }
  s.email = %q{jesse.dearing@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = %w[
    config/f1-oauth.yml
    lib/f1api.rb
    lib/f1api/activeresource/base.rb
    lib/f1api/activeresource/connection.rb
    lib/f1api/client.rb
    lib/f1api/configuration.rb
    lib/f1api/oauth.rb
    lib/f1api/oauth/credentials_authentication.rb
    lib/f1api/oauth/oauth_authentication.rb
    LICENSE
    README.md
    Rakefile
  ]

  s.test_files = %w[
    test/fixtures/access_token.rb
    test/fixtures/http.rb
    test/fixtures/request_token.rb
    test/unit/configuration_test.rb
    test/unit/credentials_test.rb
    test/unit/oauth_test.rb
  ]
  s.homepage = "http://github.com/fellowshiptech/f1api-ruby"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.summary = %q{FellowshipOne API wrapper}

  s.add_runtime_dependency('oauth', "~> 0.4.6")
  s.add_development_dependency('rspec')
end

