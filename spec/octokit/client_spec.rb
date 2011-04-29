require 'helper'

describe Octokit::Client do

  it "should connect using the endpoint configuration" do
    client = Octokit::Client.new
    endpoint = URI.parse(client.endpoint)
    connection = client.send(:connection).build_url(nil).to_s
    connection.should == endpoint.to_s
  end
  
  it 'should work with basic auth' do
    stub_request(:get, "https://foo%2Ftoken:bar@github.com/api/v2/json/commits/list/baz/quux/master").
      with(:headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => '{"commits":[]}', :headers => {})
    proc {
      Octokit::Client.new(:login => 'foo', :token => 'bar').commits('baz/quux')
    }.should_not raise_exception
  end

  it 'should work with basic auth' do
    stub_request(:get, "https://foo%2Ftoken:bar@github.com/api/v2/json/commits/list/baz/quux/master").
      with(:headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => '{"commits":[]}', :headers => {})
    proc {
      Octokit::Client.new(:login => 'foo', :token => 'bar').commits('baz/quux')
    }.should_not raise_exception
  end

end
