require 'minitest/spec'
require 'minitest/autorun'
begin; require 'turn/autorun'; rescue LoadError; end
require 'octokit'

require 'webmock/minitest'
WebMock.disable_net_connect!(:allow => 'coveralls.io')

require 'vcr'
VCR.configure do |c|
  c.default_cassette_options = {
    :serialize_with => :syck,
    :decode_compressed_response => true,
    :record => :new_episodes
  }
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

def stub_delete(url)
  stub_request(:delete, github_url(url))
end

def stub_get(url)
  stub_request(:get, github_url(url))
end

def stub_head(url)
  stub_request(:head, github_url(url))
end

def stub_patch(url)
  stub_request(:patch, github_url(url))
end

def stub_post(url)
  stub_request(:post, github_url(url))
end

def stub_put(url)
  stub_request(:put, github_url(url))
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def json_response(file)
  {
    :body => fixture(file),
    :headers => {
      :content_type => 'application/json; charset=utf-8'
    }
  }
end

def github_url(url)
  if url =~ /^http/
    url
  elsif @client && @client.authenticated?
    "https://#{@client.login}:#{@client.password}@api.github.com#{url}"
  else
    "https://api.github.com#{url}"
  end
end

