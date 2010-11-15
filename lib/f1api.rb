require 'bundler/setup'
require 'yaml'
require 'oauth'
require 'base64'
require 'uri'
require "#{File.dirname(__FILE__)}/f1api-ruby/configuration"
require "#{File.dirname(__FILE__)}/f1api-ruby/oauth"
require "#{File.dirname(__FILE__)}/f1api-ruby/oauth/credentials_authentication"
require "#{File.dirname(__FILE__)}/f1api-ruby/oauth/oauth_authentication"
require "#{File.dirname(__FILE__)}/f1api-ruby/client"
require "#{File.dirname(__FILE__)}/f1api-ruby/base"