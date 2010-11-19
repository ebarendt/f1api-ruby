Fellowship One REST API Ruby Client Library
===========================================

**NOTE**: This library is of alpha quality.  It is not meant for use in production apps.  It's definitely not feature complete and it may have bugs.

Introduction
------------
This library is an implementation of the Fellowship One REST API.  Currently we are only fielding requests and handling the OAuth tokens.  The goal is to have a library that works like ActiveResource.

Usage
-----
    require 'f1api'
    
    class Person < FellowshipOneAPI::Base
		end
		
		client.authorize!
		# If using creds in YAML file:
		# client.authorize! "username", "password"
		
		Person.connect client
		
		Person.find(12345)
		Person.find("search", {:searchFor => "Dearing", :include => "communications,addresses"})
