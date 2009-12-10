require 'test/unit'
require 'pathname'
require 'rubygems'

gem 'thoughtbot-shoulda', '>= 2.10.1'
gem 'jnunemaker-matchy', '0.4.0'
gem 'mocha', '0.9.4'
gem 'fakeweb', '>= 1.2.5'

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
  url =~ /^http/ ? url : "http://github.com/api/v2/json#{url}"
end

def stub_get(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?
  
  FakeWeb.register_uri(:get, github_url(url), options)
end

def stub_post(url, filename)
  FakeWeb.register_uri(:post, github_url(url), :body => fixture_file(filename))
end

