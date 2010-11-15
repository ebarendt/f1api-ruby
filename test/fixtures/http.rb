class HttpFixture
  def body
    "oauth_token=access&oauth_token_secret=token"
  end
  
  def [](value)
    {'Content-Location' => "#{FellowshipOneAPI::Configuration.site_url}/V1/People/123456"}[value]
  end
  
  def code
    "200"
  end
end