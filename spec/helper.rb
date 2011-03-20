require 'simplecov'
SimpleCov.start do
  add_group 'Octokit', 'lib/octokit'
  add_group 'Faraday Middleware', 'lib/faraday'
  add_group 'Specs', 'spec'
end
require 'octokit'
require 'rspec'
require 'webmock/rspec'
RSpec.configure do |config|
  config.include WebMock::API
end

def a_delete(url)
  a_request(:delete, github_url(url))
end

def a_get(url)
  a_request(:get, github_url(url))
end

def a_post(url)
  a_request(:post, github_url(url))
end

def a_put(url)
  a_request(:put, github_url(url))
end

def stub_delete(url)
  stub_request(:delete, github_url(url))
end

def stub_get(url)
  stub_request(:get, github_url(url))
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

def github_url(url)
  if url =~ /^http/
    url
  elsif @client && @client.authenticated?
    "https://pengwynn%2Ftoken:OU812@github.com/api/v#{Octokit.version}/#{Octokit.format}/#{url}"
  elsif @client && @client.oauthed?
    "https://github.com/api/v#{Octokit.version}/#{Octokit.format}/#{url}?access_token=#{@client.oauth_token}"
  else
    "https://github.com/api/v#{Octokit.version}/#{Octokit.format}/#{url}"
  end
end
