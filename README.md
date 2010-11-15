Fellowship One REST API Ruby Client Library
===========================================

**NOTE**: This library is of alpha quality.  It is not meant for use in production apps.  It's definitely not feature complete and it may have bugs.

Introduction
------------
This library is an implementation of the Fellowship One REST API.  Currently we are only fielding requests and handling the OAuth tokens.  The goal is to have a library that works like ActiveResource.

Usage
-----
For OAuth based authentication:

	 require 'f1api'
	 client = FellowshipOneAPI::Client.new
	 client.authorize! # This gives the URL to go to and authenticate
 
	 # after you have authenticated
	 client.get_access_token
 
	 client.get '/v1/People/search.xml?searchFor=Smith'

For Credentials based authentication:

	 require 'f1api'
	 client = FellowshipOneAPI::Client.new {:auth_type => :credentials}
 
	 client.authorize! "username", "password"
	 client.get '/v1/People/search.xml?searchFor=Smith'

