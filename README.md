Fellowship One REST API Ruby Client Library
===========================================

Introduction
------------
This library is an implementation of the Fellowship One REST API.  The library currently abstracts the ActiveRecord class so it can be used to easily model data from the F1 REST API.

Two Authentication Methods
--------------------------
The F1 REST API uses two methods to authenticate the user to the API: credentials for 2nd party and OAuth for 3rd party.  See the [F1 API Authentication documentation](http://developer.fellowshipone.com/docs/v1/Util/AuthDocs.help).

### OAuth (2nd or 3rd Party)

The Fellowship One API implements the OAuth v1.0 standard.  OAuth allows you to let Fellowship One handle the authentication and pass back the access tokens to a callback URL in your app.

    client = FellowshipOneAPI::Client.new
    # To be explicit: client = FellowshipOneAPI::Client.new({:auth_type => :oauth})
    client.authenticate!

### Credentials (2nd Party)

To authenticate against the API using credentials the default can be changed in the YAML configuration file or the method of authentication can be explicitly specified on the instantiation of the `FellowshipOneAPI::Client` class.  After that, the credentials of the user you are authenticating needs to be passed into the `authenticate!` or `authenticate` method. `authenticate!` will throw an exception if unable to log in, while `authenticate` will return true or false depending on if authentication was successful.

**NOTE**: `authenticate` is only available for 2nd party authentication.

    client = FellowshipOneAPI::Client.new({:auth_type => :credentials})
    if(client.authenticate "username", "password")
      # log user in
    else
      # display error
    end

Usage
-----
Install the gem:

    gem install f1api

Use it in your code:

    require 'f1api'

    class Person < FellowshipOneAPI::Base
    end

    client.authenticate!
    # If using creds in YAML file:
    # client.authenticate! "username", "password"

    FellowshipOneAPI::Base.connect client

    Person.find(12345)
    Person.find(:search, :params => {:searchFor => "Dearing", :include => "communications,addresses"})

