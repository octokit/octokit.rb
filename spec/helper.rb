unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec"
  end
end

require 'octokit'
require 'rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def a_delete(url)
  a_request(:delete, github_url(url))
end

def a_get(url)
  a_request(:get, github_url(url))
end

def a_patch(url)
  a_request(:patch, github_url(url))
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
