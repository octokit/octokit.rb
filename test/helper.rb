require 'test/unit'
require 'pathname'

require 'shoulda'
require 'matchy'
require 'mocha'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'octopussy'

FakeWeb.allow_net_connect = false

class Test::Unit::TestCase
end

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def github_url(url)
  if url =~ /^http/
    url
  elsif @client && @client.authenticated?
    "https://pengwynn%2Ftoken:OU812@github.com/api/v#{Octopussy.version}/#{Octopussy.format}/#{url}"
  else
    "https://github.com/api/v#{Octopussy.version}/#{Octopussy.format}/#{url}"
  end
end

def stub_request(method, url, filename, status=nil)
  options = {:body => ""}
  options.merge!({:body => fixture_file(filename)}) if filename
  options.merge!({:body => status.last}) if status
  options.merge!({:status => status}) if status

  FakeWeb.register_uri(method, github_url(url), options)
end

def stub_delete(*args)
  stub_request(:delete, *args)
end

def stub_get(*args)
  stub_request(:get, *args)
end

def stub_post(*args)
  stub_request(:post, *args)
end

def stub_put(*args)
  stub_request(:put, *args)
end
