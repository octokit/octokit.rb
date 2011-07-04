require 'helper'

describe Octokit::Client do

  it 'should work with basic auth' do
    stub_get("https://foo%2Ftoken:bar@api.github.com/repos/baz/quux/commits?per_page=35&sha=master").
      with(:headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => '{"commits":[]}', :headers => {})
    proc {
      Octokit::Client.new(:login => 'foo', :token => 'bar').commits('baz/quux')
    }.should_not raise_exception
  end

  it 'should work with basic auth and password' do
    stub_get("https://foo:bar@api.github.com/repos/baz/quux/commits?per_page=35&sha=master").
      with(:headers => {'Accept'=>'*/*'}).
      to_return(:status => 200, :body => '{"commits":[]}', :headers => {})
    proc {
      Octokit::Client.new(:login => 'foo', :password => 'bar').commits('baz/quux')
    }.should_not raise_exception
  end
end
