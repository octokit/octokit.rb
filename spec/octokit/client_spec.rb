require 'helper'

describe Octokit::Client do
  it "works with basic auth and password" do
    stub_get("https://foo:bar@api.github.com/repos/baz/quux/commits?per_page=35&sha=master").
      to_return(:status => 200, :body => '{"commits":[]}', :headers => {})
    expect {
      Octokit::Client.new(:login => 'foo', :password => 'bar').commits('baz/quux')
    }.not_to raise_exception
  end

  it "configures faraday from faraday_config_block" do
    mw_evaluated = false
    Octokit.configure do |c|
      c.faraday_config { |f| mw_evaluated = true }
    end
    stub_request(:get, "https://api.github.com/rate_limit").
      to_return(:status => 200, :body => '', :headers =>
                { 'X-RateLimit-Limit' => 5000, 'X-RateLimit-Remaining' => 5000})
    client = Octokit::Client.new()
    client.rate_limit
    expect(mw_evaluated).to be_true
  end


  describe "auto_traversal" do

    it "traverses a paginated response using the maximum allowed number of items per page" do
      stub_get("https://api.github.com/foo/bar?per_page=100").
        to_return(:status => 200, :body => %q{["stuff"]}, :headers =>
          { 'Link' => %q{<https://api.github.com/foo/bar?page=2>; rel="next", <https://api.github.com/foo/bar?page=3>; rel="last"} })

      stub_get("https://api.github.com/foo/bar?page=2&per_page=100").
        to_return(:status => 200, :body => %q{["even more stuff"]}, :headers =>
          { 'Link' => %q{<https://api.github.com/foo/bar?page=3>; rel="next", <https://api.github.com/foo/bar?page=3>; rel="last", <https://api.github.com/foo/bar?page=1>; rel="prev", <https://api.github.com/foo/bar?page=1>; rel="first"} })

      stub_get("https://api.github.com/foo/bar?page=3&per_page=100").
        to_return(:status => 200, :body => %q{["stuffapalooza"]}, :headers =>
          { 'Link' => %q{<https://api.github.com/foo/bar?page=2>; rel="prev", <https://api.github.com/foo/bar?page=1>; rel="first"} })

      expect(Octokit::Client.new(:auto_traversal => true).get("https://api.github.com/foo/bar", {}, 3)).to eq(['stuff', 'even more stuff', 'stuffapalooza'])
    end

    it "uses the number set in the per_page configuration option when present" do
      stub_get("https://api.github.com/foo/bar?per_page=50").
        to_return(:status => 200, :body => %q{["stuff"]}, :headers =>
          { 'Link' => %q{<https://api.github.com/foo/bar?page=2>; rel="next", <https://api.github.com/foo/bar?page=3>; rel="last"} })

      stub_get("https://api.github.com/foo/bar?page=2&per_page=50").
        to_return(:status => 200, :body => %q{["even more stuff"]}, :headers =>
          { 'Link' => %q{<https://api.github.com/foo/bar?page=3>; rel="last", <https://api.github.com/foo/bar?page=1>; rel="prev", <https://api.github.com/foo/bar?page=1>; rel="first"} })

      expect(Octokit::Client.new(:auto_traversal => true, :per_page => 50).get("https://api.github.com/foo/bar", {}, 3)).to be
    end

  end

  describe "ratelimit" do

    before(:each) do
      stub_request(:get, "https://api.github.com/rate_limit").
        to_return(:status => 200, :body => '', :headers =>
          { 'X-RateLimit-Limit' => 5000, 'X-RateLimit-Remaining' => 5000})
      @client = Octokit::Client.new()
    end

    it "gets the ratelimit-limit from the header" do
      expect(@client.ratelimit).to eq(5000)
    end

    it "gets the ratelimit-remaining using header" do
      expect(@client.ratelimit_remaining).to eq(5000)
    end

  end

  describe "unauthed rate limit" do

    before(:each) do
      Octokit.client_id = "OU812"
      Octokit.client_secret = "P4N4MA"

      stub_request(:get, "https://api.github.com/rate_limit?client_id=OU812&client_secret=P4N4MA").
        to_return(:status => 200, :body => '', :headers =>
          { 'X-RateLimit-Limit' => 62500, 'X-RateLimit-Remaining' => 62500})
      @client = Octokit::Client.new()
    end

    after(:each) do
      Octokit.reset
    end

    it "gets the ratelimit-limit from the header" do
      expect(@client.ratelimit).to eq(62500)
    end

    it "gets the ratelimit-remaining using header" do
      expect(@client.ratelimit_remaining).to eq(62500)
    end

  end

  describe "api_endpoint" do

    after(:each) do
      Octokit.reset
    end

    it "defaults to https://api.github.com" do
      client = Octokit::Client.new
      expect(client.api_endpoint).to eq('https://api.github.com/')
    end

    it "is set " do
      Octokit.api_endpoint = 'http://foo.dev'
      client = Octokit::Client.new
      expect(client.api_endpoint).to eq('http://foo.dev/')
    end
  end

  describe "request_host" do
    after(:each) { Octokit.reset }

    it "defaults to nil" do
      client = Octokit::Client.new
      expect(client.request_host).to be_nil
    end

    it "is settable" do
      Octokit.request_host = 'github.company.com'
      client = Octokit::Client.new
      expect(client.request_host).to eq('github.company.com')
    end

    it "does not change the Host header when not set" do
      Octokit.api_endpoint = 'http://github.internal'

      stub_request(:any, /.*/)
      req = stub_request(:get, 'http://github.internal/users/me').with(:headers => { 'Host' => /.*/})
      Octokit.user "me"
      expect(req).not_to have_been_requested
    end

    it "changes the Host header when set" do
      Octokit.api_endpoint = 'http://github.internal'
      Octokit.request_host = 'github.company.com'

      req = stub_request(:get, 'http://github.internal/users/me').with(:headers => { 'Host' => 'github.company.com' })
      Octokit.user "me"
      expect(req).to have_been_requested
    end
  end


end
