class HttpFixture
  attr_accessor :code

  def initialize(code = "200")
    self.code = code
  end

  def body
    "oauth_token=access&oauth_token_secret=token"
  end

  def [](value)
    {'Content-Location' => "#{FellowshipOneAPI::Configuration.site_url}/V1/People/123456"}[value]
  end
end
