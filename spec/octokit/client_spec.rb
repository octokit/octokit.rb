require 'helper'

describe Octokit::Client do
  it 'should work with basic auth and password' do
    stub_get("https://foo:bar@api.github.com/repos/baz/quux/commits?per_page=35&sha=master").
      with(:headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => '{"commits":[]}', :headers => {})
    proc {
      Octokit::Client.new(:login => 'foo', :password => 'bar').commits('baz/quux')
    }.should_not raise_exception
  end


  describe "auto_traversal" do

    it "should traverse a paginated response using the maximum allowed number of items per page" do
      stub_get("https://api.github.com/foo/bar?per_page=100").
        to_return(:status => 200, :body => %q{["stuff"]}, :headers =>
          { 'Link' => %q{<https://api.github.com/foo/bar?page=2>; rel="next", <https://api.github.com/foo/bar?page=3>; rel="last"} })

      stub_get("https://api.github.com/foo/bar?page=2&per_page=100").
        to_return(:status => 200, :body => %q{["even more stuff"]}, :headers =>
          { 'Link' => %q{<https://api.github.com/foo/bar?page=3>; rel="next", <https://api.github.com/foo/bar?page=3>; rel="last", <https://api.github.com/foo/bar?page=1>; rel="prev", <https://api.github.com/foo/bar?page=1>; rel="first"} })

      stub_get("https://api.github.com/foo/bar?page=3&per_page=100").
        to_return(:status => 200, :body => %q{["stuffapalooza"]}, :headers =>
          { 'Link' => %q{<https://api.github.com/foo/bar?page=2>; rel="prev", <https://api.github.com/foo/bar?page=1>; rel="first"} })

      Octokit::Client.new(:auto_traversal => true).get("https://api.github.com/foo/bar", {}, 3).should == ['stuff', 'even more stuff', 'stuffapalooza']
    end

    it "should use the number set in the per_page configuration option when present" do
      stub_get("https://api.github.com/foo/bar?per_page=50").
        to_return(:status => 200, :body => %q{["stuff"]}, :headers =>
          { 'Link' => %q{<https://api.github.com/foo/bar?page=2>; rel="next", <https://api.github.com/foo/bar?page=3>; rel="last"} })

      stub_get("https://api.github.com/foo/bar?page=2&per_page=50").
        to_return(:status => 200, :body => %q{["even more stuff"]}, :headers =>
          { 'Link' => %q{<https://api.github.com/foo/bar?page=3>; rel="last", <https://api.github.com/foo/bar?page=1>; rel="prev", <https://api.github.com/foo/bar?page=1>; rel="first"} })

      Octokit::Client.new(:auto_traversal => true, :per_page => 50).get("https://api.github.com/foo/bar", {}, 3).should
    end

  end

  describe "ratelimit" do

    before(:each) do
      stub_request(:get, "https://api.github.com/foo/bar").
        to_return(:status => 200, :body => '', :headers =>
          { 'X-RateLimit-Limit' => 5000, 'X-RateLimit-Remaining' => 4999})
      stub_request(:get, "https://api.github.com/foo/bar2").
        to_return(:status => 200, :body => '', :headers =>
          { 'X-RateLimit-Limit' => 5000, 'X-RateLimit-Remaining' => 4998})
      stub_request(:head, "https://api.github.com").
        to_return(:status => 200, :body => '', :headers =>
          { 'X-RateLimit-Limit' => 5000, 'X-RateLimit-Remaining' => 4998}) 
      @force = true
      @client = Octokit::Client.new()
    end

    it "should get the ratelimit-limit from the header" do
      @client.get("https://api.github.com/foo/bar")
      @client.ratelimit.should == 5000
      @client.ratelimit(true).should == 5000
    end

    it "should use the update old header when using new request ratelimit-remaining" do
      @client.get("https://api.github.com/foo/bar")
      @client.ratelimit_remaining.should == 4999
      @client.get("https://api.github.com/foo/bar2")
      @client.ratelimit_remaining.should == 4998
    end

    it "should use the new header when asking for ratelimit-remaining(force)" do
      @client.get("https://api.github.com/foo/bar")
      @client.ratelimit_remaining.should == 4999
      @client.ratelimit_remaining(true).should == 4998
    end

    it "should use the last header when asking for ratelimit-remaining" do
      @client.get("https://api.github.com/foo/bar")
      @client.ratelimit_remaining.should == 4999
      @client.ratelimit_remaining.should == 4999
    end

  end

end
